import axios from "axios";

const API_URL = "http://api.localhost/";

class AuthService {
  login(email, password) {
    return axios
      .post(API_URL + "auth/login", {
        email,
        password,
      })
      .then((response) => {
        if (response.data.auth_token) {
          localStorage.setItem(
            "auth_token",
            JSON.stringify(response.data.auth_token)
          );
        }
      });
  }

  logout() {
    localStorage.removeItem("auth_token");
  }

  register(username, email, password) {
    return axios.post(API_URL + "signup", {
      username,
      email,
      password,
    });
  }
}

export default new AuthService();
