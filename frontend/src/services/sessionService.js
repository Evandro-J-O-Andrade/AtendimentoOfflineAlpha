import axios from "axios";

export async function fetchSession() {
  const token = localStorage.getItem("token_his");
  if (!token) return null;
  const { data } = await axios.get("/api/session", {
    headers: { Authorization: `Bearer ${token}` },
  });
  return data;
}
