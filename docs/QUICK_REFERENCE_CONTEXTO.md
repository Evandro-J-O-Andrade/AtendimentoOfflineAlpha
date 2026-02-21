# Quick Reference - Context Selection Feature

## What Changed? (30-second summary)

✅ **System now requires users to select a unit (facility) and location (room) after login.**

Before:
```
Login → Directly to Dashboard
```

Now:
```
Login → Select Unit + Location → Dashboard
```

---

## How to Use (As a User)

1. **Login** with email + password
2. **Select Unit** - Click "Pronto Atendimento Central" or other unit
3. **Select Location** - Locations for that unit load automatically
4. **Confirm** - Click "Confirmar e Acessar"
5. **Dashboard** - You now see your selected unit + location in the header

---

## How to Use (As a Developer)

### Get Current Context in Any Component

```javascript
import { useAuth } from '../hooks/useAuth';

export default function MyComponent() {
  const { 
    idUnidade,               // Selected unit ID (number)
    localNome,               // Location name (string)
    unidadeNome,             // Unit name (string)
    selecionarContexto       // Method to change context
  } = useAuth();

  return (
    <div>
      <p>Unit: {unidadeNome}</p>
      <p>Location: {localNome}</p>
    </div>
  );
}
```

### Call Context API

```javascript
import { contextService } from '../services/contextService';

// Get all units
const result = await contextService.getUnidades();
// Returns: { success: true/false, unidades: [...] }

// Get locations for a unit
const result = await contextService.getLocaisPorUnidade(unitId);
// Returns: { success: true/false, locais: [...] }

// Select a unit + location
const result = await contextService.selecionarContexto(unitId, locationId);
// Returns: { success: true/false, contexto: {...} }
```

### Check AuthContext State

```javascript
import { useAuth } from '../hooks/useAuth';

const auth = useAuth();

// All available fields:
auth.usuario                    // User object
auth.idUnidade                  // Current unit ID
auth.idLocalOperacional         // Current location ID
auth.unidadeNome               // Current unit name
auth.localNome                 // Current location name
auth.localSala                 // Current room number
auth.selecionandoContexto      // Is selecting context? (boolean)

// Available methods:
auth.login(email, password)    // Login
auth.logout()                  // Logout
auth.selecionarContexto(id_u, id_l)  // Change context
```

---

## Backend Integration (Next Steps)

### Update Procedures to Use Context

Current (doesn't use context):
```sql
PROCEDURE sp_listar_pacientes(
  p_filtro VARCHAR(100)
)
```

Next (will use context):
```sql
PROCEDURE sp_listar_pacientes(
  p_id_sessao_usuario INT,    -- ADD THIS
  p_filtro VARCHAR(100)
)
-- Inside procedure, get context from sessao_usuario:
SELECT id_unidade, id_local_operacional INTO v_unidade, v_local
FROM sessao_usuario
WHERE id_sessao_usuario = p_id_sessao_usuario;

-- Filter results
WHERE unidade = v_unidade AND local = v_local;
```

### CallFromBackend Example

```javascript
// Frontend (JavaScript)
const response = await api.get('/api/patients', {
  headers: { 'Authorization': `Bearer ${token}` }
});
// JWT token contains user + unidade + local_operacional

// Backend (Node.js)
app.get('/api/patients', authMiddleware, async (req, res) => {
  // authMiddleware validates JWT and extracts user info
  const { id_usuario, id_unidade, id_local_operacional } = req.user;
  
  // Call procedure with context
  connection.query(
    'CALL sp_listar_pacientes(?, ?, ?)',
    [id_usuario, id_unidade, id_local_operacional],
    (err, results) => { ... }
  );
});

// Backend (SQL Procedure)
DELIMITER //
CREATE PROCEDURE sp_listar_pacientes(
  IN p_id_usuario INT,
  IN p_id_unidade INT,
  IN p_id_local_operacional INT
)
BEGIN
  -- Only return patients for this unit + location
  SELECT * FROM paciente
  WHERE id_unidade = p_id_unidade
    AND id_local_operacional = p_id_local_operacional;
END //
DELIMITER ;
```

---

## Files Quick Reference

| File | Purpose | Why Changed |
|------|---------|------------|
| `AuthContext.jsx` | State management | Now stores unit + location |
| `App.jsx` | Routing | Added ProtectedRoute + /contexto |
| `Header.jsx` | Display | Shows selected unit + location |
| `ContextoSelectionPage.jsx` | Post-login UI | NEW: unit + location selector |
| `contextService.js` | API wrapper | NEW: 3 methods for context |

---

## Testing Quick Checklist

- [ ] Login works
- [ ] Redirected to context selection page
- [ ] Unit list loads
- [ ] Click unit → locations load in right column
- [ ] Click location → confirm button enables
- [ ] Click confirm → dashboard accessible
- [ ] Header shows unit + location badges
- [ ] Refresh page → context persists
- [ ] Logout → context cleared

---

## Troubleshooting

### "Erro ao carregar unidades" Error
1. Check backend running: `npm start` in `/backend`
2. Check database has data: `SELECT * FROM unidade WHERE ativo = 1;`
3. Check browser console for error details
4. Try logout → login again

### Context Not Showing in Header
1. On mobile? Context badges hidden for space (ok)
2. Desktop? Check React DevTools → AuthContext value
3. If empty → re-select context or logout/login
4. View localStorage: `localStorage.getItem('contexto')`

### Can't Access Dashboard After Context Selection
1. Check browser console for errors
2. Check Network tab → any 401/403 errors?
3. Try `localStorage.clear()` and login fresh
4. Verify ProtectedRoute is working (redirect to /contexto?)

---

## Performance Tips

### Caching (Frontend - Future)
```javascript
// Cache units/locations in localStorage or state
// Avoid re-fetching on every visit
const cachedUnidades = localStorage.getItem('unidades');
if (cachedUnidades && isFresh()) {
  useCache();
} else {
  fetchFresh();
}
```

### Optimization (Backend - Future)
```sql
-- Index locations by unit for faster queries
CREATE INDEX idx_local_unidade ON local_operacional(id_unidade);

-- Cache active unidades
SELECT id_unidade, nome, tipo FROM unidade 
WHERE ativo = 1
-- Add to Redis for <1ms responses
```

---

## Security Notes

### Context Validated Server-Side (Always)
- `/context/selecionar` validates both IDs exist
- JWT token includes user ID (prevents spoofing)
- Procedures will filter by unit + location (data isolation)

### localStorage Risk (Managed)
- Context data is non-sensitive (names, IDs only)
- Sensitive data (passwords, medical records) stay on backend
- localStorage cleared on logout
- Works offline (context doesn't require server to display)

### What NOT to do
- ❌ Don't store passwords in context
- ❌ Don't store full patient records in context
- ❌ Don't trust context for security (always validate server-side)
- ❌ Don't send context in URL parameters

---

## Feature Compatibility

### ✅ Works With
- Redux (context is separate, can coexist)
- Authentication flow (integrates seamlessly)
- Protected routes (ProtectedRoute logic handles both checks)
- localStorage (persists across page reloads)
- Mobile (fully responsive UI)

### ⚠️ Known Limitations
- Can't switch units without logic (future feature)
- No permission checks yet (future enhancement)
- Context lost on logout (by design, security)

---

## Version Info

- **Release Date:** February 21, 2026
- **Context API Version:** 1.0
- **Database Schema Version:** Requires `unidade` + `local_operacional` tables
- **Frontend Framework:** React 18+
- **Backend Framework:** Express.js 4+

---

## Quick Links

- 📄 Full Implementation: `docs/CONTEXTO_SELECTION_IMPLEMENTATION.md`
- 🧪 Testing Guide: `docs/TESTE_MANUAL_CONTEXTO.md`
- 📊 Status Report: `docs/STATUS_CONTEXTO_SELECTION.md`
- 🔧 This Guide: `docs/QUICK_REFERENCE_CONTEXTO.md`

---

## Still Have Questions?

1. Check the docs above
2. Search codebase for `contexto` or `selecionarContexto`
3. Check browser DevTools → React → AuthContext
4. Check network requests → `/api/context/*` endpoints
5. Review error messages in browser console

Good luck! 🚀
