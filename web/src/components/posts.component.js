import React, { Component } from "react";
import UserService from "../services/user.service";
import PostService from "../services/post.service";
import ReactPaginate from "react-paginate";

export default class Users extends Component {
  constructor(props) {
    super(props);

    this.state = {
      listPost: [],
      pages: null,
      userRole: "",
      query: "",
      userEmail: '',
    };
  }

  componentDidMount() {
    PostService.getListPost("", 1).then((res) => {
      if (res) {
        this.setState({ listPost: res.data.posts, pages: res.data.pages });
      }
    });
    UserService.getCurrentUser().then((res) => {
      if (res) {
        this.setState({
          userRole: res.data.role,
          userEmail: res.data.email
        });
      }
    });
  }

  handlePageClick = (event) => {
    let pages = event.selected + 1;
    const { query } = this.state;
    PostService.getListPost(query, pages).then((res) => {
      if (res) {
        this.setState({ listPost: res.data.posts });
      }
    });
  };

  handleEdit = (alias_name) => {
    this.props.history.push(`/post/edit/${alias_name}`);
  };

  handleView = (alias_name) => {
    this.props.history.push(`/post/detail/${alias_name}`);
  };

  handleCreate = () => {
    this.props.history.push('/post/create');
  };

  handleDelete = (alias_name) => {
    PostService.deletePost(alias_name).then((res) => {
      if (res) {
        if (res?.data?.result) {
          this.props.history.push('/posts');
        } else {
          alert(res.data?.message);
        }
      }
    });
  };


  handleChangeInput = (event) => {
    const query = event.target.value;
    PostService.getListPost(query, 1).then((res) => {
      if (res) {
        this.setState({ listPost: res.data.posts, pages: res.data.pages });
      }
    });
  };

  render() {
    let { listPost, pages, userRole, userEmail } = this.state;

    let posts = listPost.map((item) => {
      const { id, title, email, published_date, alias_name } = item;
      return (
        <tr key={id}>
          <td>{id}</td>
          <td>{title}</td>
          <td>{email}</td>
          <td>{published_date}</td>
          <td>
            <button onClick={() => this.handleView(alias_name)}>
              View
            </button>
          </td>
          {(userRole === "admin" || userEmail === email) && (
            <>
              <td>
                <button onClick={() => this.handleEdit(alias_name)}>
                  Edit
                </button>
              </td>
              <td>
                <button onClick={() => this.handleDelete(alias_name)}>
                  Delete
                </button>
              </td>
            </>
          )}
        </tr>
      );
    });
    return (
      <div>
        <div className="header button-group">
          <input
            className="query"
            type="text"
            placeholder="Search..."
            onChange={this.handleChangeInput}
          />
          <button onClick={this.handleCreate} className="btn btn-primary">Write a blog</button>
        </div>

        <table className="Table">
          <thead>
            <tr>
              <th>S/N</th>
              <th>Title</th>
              <th>Creater</th>
              <th>Published date</th>
              <th colSpan={3}>Action</th>
            </tr>
          </thead>
          <tbody>{posts}</tbody>
        </table>
        <ReactPaginate
          previousLabel={"prev"}
          nextLabel={"next"}
          pageCount={pages}
          onPageChange={this.handlePageClick}
          containerClassName={"pagination"}
          activeClassName={"active"}
        />
      </div>
    );
  }
}
