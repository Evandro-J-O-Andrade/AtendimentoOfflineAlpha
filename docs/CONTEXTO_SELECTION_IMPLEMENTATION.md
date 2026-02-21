# Context Selection Flow - Implementation Complete (Feb 21, 2026)

## Overview

Implemented **multi-unit + multi-location awareness** for the Pronto Atendimento system. Every user must now select which facility (unidade) and which room/department (local_operacional) they're working in after login.

## What Was Implemented

### Backend (Already Done in Previous Session)

**📍 3 New Endpoints:**
- `GET /api/context/unidades` → List all active units
- `GET /api/context/locais/:id_unidade` → List locations for a specific unit
- `POST /api/context/selecionar` → Save context selection to session

**Files:**
- `backend/src/controllers/context.controller.js`
- `backend/src/routes/context.routes.js`
- `backend/src/index.js` (updated with route registration)

### Frontend (Completed This Session)

#### 1. **Updated AuthContext** (`frontend/src/context/AuthContext.jsx`)
```javascript
// New state fields:
- idUnidade, idLocalOperacional
- unidadeNome, unidadeTipo
- localNome, localCodigo, localTipo, localSala
- selecionandoContexto (flag to trigger selection flow)

// New action type: SET_CONTEXTO
// Updated: RESTORE_SESSION to restore context from localStorage
// New method: selecionarContexto(id_unidade, id_local_operacional)
```

#### 2. **Updated Header** (`frontend/src/components/Header/Header.jsx`)
```javascript
// Now displays:
- 🏢 Selected Unit: "Unidade Name"
- 📍 Selected Location: "Local Name - Sala X"
// Visible in all pages after context selection
```

#### 3. **Created Context Service** (`frontend/src/services/contextService.js`)
```javascript
// Encapsulates API calls:
- getUnidades() → GET /context/unidades
- getLocaisPorUnidade(id) → GET /context/locais/:id
- selecionarContexto(idUnidade, localId) → POST /context/selecionar
```

#### 4. **Created Context Selection Page** (`frontend/src/pages/ContextoSelectionPage.jsx`)
```javascript
// Features:
- Two-column layout: Units on left, Locations on right
- Real-time: Selecting unit loads matching locations
- Visual feedback: Selected items highlight in blue/green
- Confirm button: Validates both selections before proceeding
- Summary message: "You'll access [Local] in [Unit]"
- Back button: Return to login if needed
- Responsive design: Mobile-friendly, Tailwind CSS
```

#### 5. **Updated App Routes** (`frontend/src/App.jsx`)
```javascript
// New:
- ProtectedRoute component: Validates user + context
- Route: /contexto → ContextoSelectionPage
- Protection: If selecionandoContexto OR context not set → redirect to /contexto

// Flow:
1. Login → JWT token received, selecionandoContexto = true
2. Any route accessed → ProtectedRoute checks context
3. If missing context → Redirect to /contexto
4. User selects unit + location → context saved to localStorage + AuthContext
5. Dashboard accessible → Context visible in header
```

## Database Structure (For Reference)

```sql
-- Units (Facilities)
unidade {
  id_unidade (PK)
  nome: "Pronto Atendimento Central"
  tipo: UPA | HOSPITAL | PA | CLINICA
  cnes: "1234567"
  ativo: 1
}

-- Operating Locations
local_operacional {
  id_local_operacional (PK)
  id_unidade (FK)
  codigo: "REC-001"
  tipo: RECEPCAO | TRIAGEM | MEDICO_CLINICO | FARMACIA | RX | LAB | ...
  sala: "Sala A1"
  ativo: 1
}

-- User Sessions (Capture Context)
sessao_usuario {
  id_sessao_usuario (PK)
  id_usuario (FK)
  id_sistema (FK)
  id_unidade (FK) ← CONTEXT
  id_local_operacional (FK) ← CONTEXT
  token: "JWT..."
  ativo: 1
  expira_em: timestamp
}
```

## User Flow (Video Script)

1. **Login Page**
   - User enters email + password
   - System validates credentials
   - JWT token returned

2. **Automatic Redirect to Context Selection**
   - ProtectedRoute component detects `selecionandoContexto = true`
   - User redirected to `/contexto` (ContextoSelectionPage)

3. **Context Selection Page**
   - Two columns appear:
     - Left: List of units (e.g., "Pronto Atendimento Central", "UPA Zone 2")
     - Right: List of locations for selected unit (e.g., "Recepção", "Triagem", "Farmácia")
   - User clicks unit → locations load in real-time
   - User clicks location → confirm button enables
   - Summary shows: "You'll access Farmácia in Pronto Atendimento Central"
   - Click "Confirmar e Acessar"

4. **Dashboard Access**
   - Context saved to localStorage (survives page reload)
   - Context stored in AuthContext state
   - Header displays: "🏢 Pronto Atendimento Central | 📍 Farmácia"
   - User can now access all pages with selected context

## Code Examples

### Using Context in Components

```javascript
import { useAuth } from '../hooks/useAuth';

export default function MyComponent() {
  const { idUnidade, localNome, localSala, selecionarContexto } = useAuth();

  // Display current context
  console.log(`Working in: ${localNome} of unit ${idUnidade}`);

  // Change context from menu
  const handleChangeContext = async () => {
    await selecionarContexto(newUnitId, newLocationId);
    // UI updates automatically, localStorage saves
  };

  return (
    <div>
      <p>Current Location: {localNome} - Sala {localSala}</p>
    </div>
  );
}
```

### Backend Procedure Usage (Next Step)

Once backend procedures are updated to use `p_id_sessao_usuario`:

```javascript
// Frontend API call
const result = await api.get('/api/patients', {
  headers: { 'X-Sessao': sessionId } // or in JWT
});

// Backend procedure receives context from session
CALL sp_listar_pacientes(
  p_id_sessao_usuario,  // Context resolved server-side
  p_filtro,
  @p_result
);
// sp resolves: id_unidade, id_local_operacional from sessao_usuario
```

## Files Summary

### New Files
1. `frontend/src/services/contextService.js` - API wrapper for context endpoints
2. `frontend/src/pages/ContextoSelectionPage.jsx` - Context selection UI

### Updated Files
1. `frontend/src/context/AuthContext.jsx` - Added context state management
2. `frontend/src/components/Header/Header.jsx` - Display selected unit/location
3. `frontend/src/App.jsx` - Added ProtectedRoute + /contexto route

### Backend (Already Implemented)
1. `backend/src/controllers/context.controller.js`
2. `backend/src/routes/context.routes.js`
3. `backend/src/index.js` (routes registered)

## Testing Checklist

- [ ] Start backend: `npm start` (backend folder)
- [ ] Start frontend: `npm run dev` (frontend folder)
- [ ] Login with test credentials
- [ ] Verify redirect to `/contexto`
- [ ] Click first unit → verify locations load
- [ ] Click first location → verify summary shows
- [ ] Click "Confirmar e Acessar"
- [ ] Verify redirect to `/dashboard`
- [ ] Verify header shows: "🏢 [Unit Name] | 📍 [Location Name]"
- [ ] Refresh page → verify context persists (localStorage)
- [ ] Logout → verify context cleared

## Next Steps (Recommended)

### Immediate (1-2 hours)
- [ ] Test full login → context selection → dashboard flow manually
- [ ] Verify localStorage persistence works
- [ ] Test with multiple units/locations

### Short Term (4 hours)
- [ ] Add "Change Context" button to header → re-run selection flow
- [ ] Update Dashboard to show context info prominently
- [ ] Create context-aware pages (show only data for selected unit)

### Medium Term (2 days)
- [ ] Backend: Ensure all procedures use `p_id_sessao_usuario` parameter
- [ ] Backend: Add permission checks (user can access unit X?)
- [ ] Frontend: Gray out units/locations user doesn't have access to
- [ ] Add notification when context changes

### Optional (Future)
- [ ] Cache unidades/locais in frontend (reduce API calls)
- [ ] Session timeout → re-prompt for context selection
- [ ] Audit trail: log which users accessed which units/locations
- [ ] Support multiple context switches without logout

## Known Limitations

1. **No Context Switching Yet** - Currently requires logout to change unit/location
   - Fix: Add header menu option to go back to `/contexto`
   
2. **No Permission Checking** - All users see all units
   - Fix: Backend should filter by user permissions
   
3. **Backend Procedures Not Updated** - Still expect individual params
   - Fix: Update procedures to use `p_id_sessao_usuario` pattern

## Architecture Notes

### Why This Matters

The Pronto Atendimento system is **multi-facility** by design:
- One organization may run MULTIPLE units (UPA, PA, Clinics)
- Each unit has MULTIPLE departments (Receção, Triagem, Farmácia)
- Users may work in SEVERAL units (cross-trained staff)
- Data must be isolated by unit + location (security + compliance)

### How It Integrates

```
Login Page
    ↓
JWT Token + selecionandoContexto=true
    ↓
ProtectedRoute Check
    ↓ (missing context)
/contexto Page
    ↓
User selects unit + location
    ↓
POST /api/context/selecionar
    ↓
Context stored in localStorage + AuthContext
    ↓
selecionandoContexto=false
    ↓ (can access protected routes now)
Dashboard + Other Protected Pages
    ↓ (with context visible in header)
```

---

**Status:** ✅ Complete - Ready for testing
**Date:** February 21, 2026
**Duration:** ~1 hour implementation
