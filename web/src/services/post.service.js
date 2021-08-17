import axios from "axios";
import authHeader from "./auth-header";

const API_URL = "http://api.localhost/";

class PostService {
  getListPost(query, page) {
    return axios.get(API_URL + `posts?page=${page}&search=${query}`, {
      headers: authHeader(),
    });
  }

  getTopPost() {
    return axios.get(API_URL + 'top_post', {
      headers: authHeader()
    });
  }

  getDetailPost(query) {
    return axios.get(API_URL + `posts/${query}`, {
      headers: authHeader(),
    });
  }

  likePost(query) {
    return axios.put(
      API_URL + `posts/${query}/like`,
      {},
      { headers: authHeader() }
    );
  }

  createPost(params, mode, query) {
    if (mode === 'create') {
      return axios.post(
        API_URL + "posts",
        params,
        { headers: authHeader() }
      );
    } else if (mode === 'edit') {
      return axios.put(
        API_URL + `posts/${query}`,
        params,
        { headers: authHeader() }
      );
    }
  }

  deletePost(query) {
    return axios.delete(
      API_URL + `posts/${query}`,
      { headers: authHeader() }
    );
  }
}

export default new PostService();
