import { readdirSync, statSync, readFileSync } from 'fs'
import { join, relative, dirname, resolve } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const srcDir = resolve(__dirname, '..', 'src')
const packageRoot = resolve(__dirname, '..')

const ALLOWED_EXTERNAL_PACKAGES = [
  '@atendimentooffline/contracts',
  '@atendimentooffline/api',
]

const FORBIDDEN_PREFIXES = [
  'apps/',
  'database/',
  'modules/',
  '@atendimentooffline/enterprise-',
]

function walkDir(dir) {
  const files = []
  const entries = readdirSync(dir, { withFileTypes: true })
  for (const entry of entries) {
    const fullPath = join(dir, entry.name)
    if (entry.isDirectory()) {
      files.push(...walkDir(fullPath))
    } else if (entry.name.endsWith('.ts') && !entry.name.endsWith('.d.ts')) {
      files.push(fullPath)
    }
  }
  return files
}

function validateFile(filePath) {
  const content = readFileSync(filePath, 'utf-8')
  const violations = []

  const lines = content.split('\n')
  for (const line of lines) {
    const trimmed = line.trim()

    const importMatch = trimmed.match(/^import\s+.*?\s+from\s+['"]([^'"]+)['"]/)
    if (!importMatch) continue
    const importSource = importMatch[1]

    if (importSource.startsWith('node:') || importSource.startsWith('#')) continue

    if (importSource.startsWith('.') || importSource.startsWith('/')) {
      const resolved = resolve(dirname(filePath), importSource)
      const relFromSrc = relative(srcDir, resolved)
      if (relFromSrc.startsWith('..')) {
        violations.push(`Relative import escapes src boundary: ${importSource}`)
      }
      continue
    }

    const isAllowed = ALLOWED_EXTERNAL_PACKAGES.some(
      pkg => importSource === pkg || importSource.startsWith(pkg + '/')
    )
    if (isAllowed) continue

    const isForbidden = FORBIDDEN_PREFIXES.some(prefix =>
      importSource.startsWith(prefix)
    )
    if (isForbidden) {
      violations.push(`Forbidden import: ${importSource}`)
    }
  }

  return violations
}

function main() {
  const files = walkDir(srcDir)
  let hasErrors = false
  const violationsByFile = []

  for (const file of files) {
    const relPath = relative(packageRoot, file)
    const violations = validateFile(file)
    if (violations.length > 0) {
      hasErrors = true
      violationsByFile.push({ file: relPath, violations })
    }
  }

  if (hasErrors) {
    console.log('')
    for (const entry of violationsByFile) {
      console.error(`  ${entry.file}:`)
      for (const v of entry.violations) {
        console.error(`    - ${v}`)
      }
    }
    console.log('')
    console.error('Architecture validation FAILED: forbidden dependencies detected.')
    process.exit(1)
  }

  console.log(`Architecture validation passed: ${files.length} source files checked, no forbidden dependencies.`)
}

main()
