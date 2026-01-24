import axios from "axios";

// Em PRODUÇÃO: use /api (Apache Alias /api -> src/api)
// Em DEV (vite): use /api + proxy do vite.config.js
const API_BASE = import.meta.env.VITE_API_BASE || "/api";

const api = axios.create({
  baseURL: API_BASE,
  headers: { "Content-Type": "application/json" },
  withCredentials: true,
});

let isRefreshing = false;
let refreshSubscribers = [];

function onRefreshed(token) {
  refreshSubscribers.forEach((cb) => cb(token));
  refreshSubscribers = [];
}

function addRefreshSubscriber(cb) {
  refreshSubscribers.push(cb);
}

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (res) => res,
  async (err) => {
    const originalRequest = err.config;

    // Se nem existe response (erro de rede), apenas propaga
    if (!err.response) return Promise.reject(err);

    const status = err.response.status;
    const url = originalRequest?.url || "";

    // Anti-loop: não tenta refresh em endpoints de auth
    if (
      url.includes("/auth/auth.php") ||
      url.includes("/auth.php") ||
      url.includes("/auth/refresh.php") ||
      url.includes("/auth/me.php")
    ) {
      localStorage.removeItem("token");
      return Promise.reject(err);
    }

    if (status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        return new Promise((resolve) => {
          addRefreshSubscriber((token) => {
            originalRequest.headers.Authorization = `Bearer ${token}`;
            resolve(api(originalRequest));
          });
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const resp = await axios.post(`${API_BASE}/auth/refresh.php`, {}, { withCredentials: true });

        const { token } = resp.data || {};
        if (token) localStorage.setItem("token", token);

        onRefreshed(token);
        originalRequest.headers.Authorization = `Bearer ${token}`;
        return api(originalRequest);
      } catch (e) {
        localStorage.removeItem("token");
        return Promise.reject(err);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(err);
  }
);

export default api;
