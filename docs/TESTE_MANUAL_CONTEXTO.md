# Test Manual - Context Selection Flow (Feb 21, 2026)

## Prerequisites

1. Backend running: `npm start` in `/backend` folder
2. Frontend running: `npm run dev` in `/frontend` folder
3. Database: pronto_atendimento with test data
4. Test user credentials: check `scripts/seed_users.php` or use `admin@test.com` / `123456`

## Test Scenario 1: Login → Context Selection → Dashboard

### Step 1: Login
1. Navigate to `http://localhost:5173/login`
2. Enter credentials:
   - Email: `admin@test.com`
   - Password: `123456`
3. Click "Entrar"

**Expected:**
- ✅ Login page processes request
- ✅ JWT token received and stored in localStorage
- ✅ Redirect to `/contexto` (Context Selection Page)
- ✅ Page shows title: "Selecione sua Unidade e Sala"
- ✅ Welcome message: "Bem-vindo, [User Name]!"

### Step 2: Context Selection Page Load
**Expected after 1 second:**
- ✅ Left column shows list of units (unidades)
  - Examples: "Pronto Atendimento Central", "UPA Zone 2", "Clinica Privada"
  - Each shows type: "Pronto Atendimento", "UPA", etc.
  - CNES number visible if available
- ✅ Right column shows: "Selecione uma unidade"
- ✅ No location/room list yet
- ✅ "Confirmar e Acessar" button disabled (grayed out)

### Step 3: Select a Unit
1. Click on first unit in left column (e.g., "Pronto Atendimento Central")

**Expected immediately:**
- ✅ Unit highlighted in blue with darker background
- ✅ Right column shows loading spinner
- ✅ After 1-2 seconds, right column loads locations list:
  - "Recepção" (type: Recepção)
  - "Triagem" (type: Triagem)
  - "Clínico" (type: Médico Clínico)
  - "Farmácia" (type: Farmácia)
  - "Laboratório" (type: Laboratório)
  - etc.
- ✅ Each location shows:
  - Name
  - Type name
  - Sala number (if available)

### Step 4: Select a Location
1. Click on "Farmácia" in right column

**Expected immediately:**
- ✅ Location highlighted in green
- ✅ Summary box appears below: "Você vai acessar Farmácia da unidade Pronto Atendimento Central"
- ✅ "Confirmar e Acessar" button becomes enabled (blue, clickable)

### Step 5: Confirm Selection
1. Click "Confirmar e Acessar" button

**Expected within 2 seconds:**
- ✅ Button shows loading state: "Confirmando..."
- ✅ API call made: `POST /api/context/selecionar`
  - Payload: `{ id_unidade: 1, id_local_operacional: 10 }`
- ✅ Response received with context data
- ✅ Context saved to localStorage (check DevTools → Application → localStorage)
  - Key `contexto` should contain JSON with unit/location info
- ✅ AuthContext state updated
- ✅ Redirect to `/dashboard`

### Step 6: Verify Dashboard & Header
1. Now on Dashboard page

**Expected:**
- ✅ Header visible at top with context info:
  - Blue badge: "🏢 Pronto Atendimento Central"
  - Green badge: "📍 Farmácia - Sala X"
  - (On mobile, may be hidden - resize to desktop to see)
- ✅ Dashboard content loads
- ✅ User menu (avatar) visible in top right
- ✅ Navigation menu visible

### Step 7: Test localStorage Persistence
1. Refresh page (F5 or Cmd+R)

**Expected:**
- ✅ Page reloads (no login prompt)
- ✅ AuthContext restores from localStorage automatically
  - `usuario` field restored
  - `contexto` field restored
- ✅ Dashboard still shows context in header
- ✅ No redirect to login or context selection

### Step 8: Test Logout
1. Click avatar in top right → Click "Sair"

**Expected:**
- ✅ localStorage cleared:
  - `accessToken` removed
  - `usuario` removed
  - `contexto` removed
- ✅ Redirect to `/login`
- ✅ Refresh page → still on login (not cached)

---

## Test Scenario 2: Multiple Units/Locations

### Setup
1. Have 2+ units in database
2. Have multiple locations in each unit

### Test Steps
1. Login → Context Selection
2. Select Unit A → verify locations list for Unit A loads
3. Click Unit B → verify locations list CHANGES to Unit B locations
4. Click location in Unit B → confirm and access
5. Verify header shows Unit B info
6. Logout → Login → should return to Unidade selection, not saved context anymore

**Notes:**
- Context is unit+location specific
- Changing unit clears selected location (must reselect)
- localStorage only persists last selected context

---

## Test Scenario 3: Error Handling

### Test Network Error
1. Open DevTools → Network tab
2. Login
3. On Context Selection page, use DevTools to throttle network
4. Select a unit → locations request will be slow or fail

**Expected:**
- ✅ Error message appears: "Erro ao carregar locais"
- ✅ Can retry or go back
- ✅ No infinite loading spinners

### Test Invalid Context
1. Manually edit localStorage `contexto` with invalid IDs
2. Refresh page

**Expected:**
- ✅ Page loads but context may be empty
- ✅ ProtectedRoute might redirect to `/contexto` again
- ✅ No crashes or errors in console

---

## Test Scenario 4: Browser DevTools Inspection

### Check localStorage
1. Login → Select Context → Dashboard
2. Open DevTools (F12) → Application → Storage → localStorage

**Expected keys:**
- `accessToken`: JWT token (eyJhbGc...)
- `usuario`: JSON with user data
- `contexto`: JSON with unit/location data
  ```json
  {
    "id_unidade": 1,
    "unidade_nome": "Pronto Atendimento Central",
    "unidade_tipo": "PA",
    "id_local_operacional": 10,
    "local_nome": "Farmácia",
    "local_codigo": "FAR-001",
    "local_tipo": "FARMACIA",
    "local_sala": "Sala A1"
  }
  ```

### Check Network Requests
1. Open DevTools → Network tab
2. Login and go through context selection
3. Observe requests:

**Expected:**
```
POST /api/login
  ↓ (success, token returned)
GET /api/context/unidades
  ↓ (success, units list)
GET /api/context/locais/1
  ↓ (success, locations for unit 1)
POST /api/context/selecionar
  ↓ (success, context confirmed)
GET /api/dashboard (or other pages)
  ↓ (success, with Authorization header containing token)
```

**Verify:**
- ✅ Each request has `Authorization: Bearer [token]` header
- ✅ Status codes are 200/201 for success
- ✅ No 401/403 errors (should mean auth bug if present)

### Check React State
1. Install React DevTools extension (Chrome/Firefox)
2. Open DevTools → Components tab
3. Find `<AuthContext.Provider>` component
4. Expand and check context value:

**Expected fields visible:**
- `usuario` field
- `idUnidade` = 1
- `idLocalOperacional` = 10
- `unidadeNome` = "Pronto Atendimento Central"
- `localNome` = "Farmácia"
- `selecionandoContexto` = false
- `login()`, `logout()`, `selecionarContexto()` methods

---

## Test Scenario 5: Mobile/Responsive

### On Mobile Device or Responsive Mode
1. DevTools → Toggle Device Toolbar (Ctrl+Shift+M)
2. Set to iPhone 12 size
3. Login → Context Selection

**Expected:**
- ✅ Page is fully responsive
- ✅ Two-column layout converts to single column on mobile
- ✅ Unit list appears first, then location list
- ✅ All buttons are clickable (adequate tap targets)
- ✅ Text is readable without zoom
- ✅ Header context badges might be hidden (that's ok, priorities)

---

## Troubleshooting Guide

### Issue: Stuck on Context Selection Page After Login
**Cause:** AuthContext not properly set `selecionandoContexto = true`
**Fix:**
1. Check browser console for errors
2. Check localStorage has `accessToken`
3. Verify backend `/context/unidades` endpoint is working
4. Try manually navigating to `/dashboard` - should redirect back to `/contexto`

### Issue: "Erro ao carregar unidades" Message
**Cause:** Backend endpoint not responding or no data
**Fix:**
1. Verify backend running: `curl http://localhost:3000/api/context/unidades`
2. Check backend logs for errors
3. Ensure JWT token in request header (check Network tab)
4. Verify data in database:
   ```sql
   SELECT * FROM unidade WHERE ativo = 1;
   SELECT * FROM local_operacional WHERE ativo = 1;
   ```

### Issue: Can Select Context but Dashboard Access Denied
**Cause:** JWT token might be expired or corrupted
**Fix:**
1. Logout completely
2. Clear all localStorage manually
3. Login fresh and go through context selection again

### Issue: Context Lost After Page Refresh
**Cause:** localStorage not saving properly
**Fix:**
1. Check browser privacy settings (may block localStorage)
2. Check browser DevTools → Application → Storage → localStorage
3. Verify `contexto` key exists and has valid JSON
4. Try different browser (Chrome vs Firefox vs Safari)

### Issue: Header Not Showing Unit/Location Badges
**Cause:** Normal on mobile, check screen width
**Fix:**
1. Resize to desktop (1024px+)
2. Check DevTools → Inspect element on header
3. Verify Header component is receiving `unidadeNome` and `localNome` props
4. Check React DevTools for context value

---

## Checklist for Verification

### Backend
- [ ] Context controller created and working
- [ ] Context routes mounted on `/api/context/*`
- [ ] All three endpoints responding with 200 status
- [ ] Endpoint properly validates id_unidade and id_local_operacional
- [ ] Authorization middleware working (401 if no token)

### Frontend
- [ ] AuthContext has new state fields
- [ ] contextService module created with 3 methods
- [ ] ContextoSelectionPage renders properly
- [ ] App.jsx has ProtectedRoute component
- [ ] App.jsx has `/contexto` route
- [ ] Header displays context info correctly
- [ ] All imports are correct (no "module not found" errors)

### Integration
- [ ] Login → Context Selection flow works end-to-end
- [ ] Context persists to localStorage
- [ ] Page refresh maintains context
- [ ] Logout clears context
- [ ] Protected routes require context

### User Experience
- [ ] Loading states visible while fetching data
- [ ] Error messages are clear and actionable
- [ ] Disabled buttons show visual feedback
- [ ] Summary message helps user confirm selection
- [ ] Mobile responsive and usable

---

## Quick Test Command Line

```bash
# Terminal 1: Backend
cd backend
npm start

# Terminal 2: Frontend
cd frontend
npm run dev

# Terminal 3: Quick API test (after login, get JWT)
BEARER_TOKEN="[paste_token_from_localStorage]"

# Test endpoints
curl -H "Authorization: Bearer $BEARER_TOKEN" http://localhost:3000/api/context/unidades
curl -H "Authorization: Bearer $BEARER_TOKEN" http://localhost:3000/api/context/locais/1
curl -X POST -H "Authorization: Bearer $BEARER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id_unidade":1,"id_local_operacional":10}' \
  http://localhost:3000/api/context/selecionar
```

---

**Status:** Ready for testing
**Last Updated:** February 21, 2026
