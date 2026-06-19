import api from "../api/api";

export async function fetchSession() {
  const token = localStorage.getItem("token_his");
  if (!token) return null;

  const { data } = await api.get(`/session`);
  return data;
}
