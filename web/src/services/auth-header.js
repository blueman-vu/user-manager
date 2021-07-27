export default function authHeader() {
  const token = JSON.parse(localStorage.getItem("auth_token"));

  if (token) {
    return {
      Authorization: token,
      "Content-Type": "application/json",
    };
  } else {
    return {};
  }
}
