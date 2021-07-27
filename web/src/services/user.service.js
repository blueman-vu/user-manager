import axios from "axios";
import authHeader from "./auth-header";

const API_URL = "http://api.localhost/";

class UserService {
  getCurrentUser() {
    return axios.get(API_URL + "get_user", { headers: authHeader() });
  }
  getListUser(query, page) {
    return axios.get(API_URL + `users?page=${page}&search=${query}`, {
      headers: authHeader(),
    });
  }
  blockUser(id) {
    return axios.post(
      API_URL + "block_user",
      { id: id },
      { headers: authHeader() }
    );
  }
  deleteUser(id) {
    return axios.post(
      API_URL + "delete_user",
      { id: id },
      { headers: authHeader() }
    );
  }
}

export default new UserService();
