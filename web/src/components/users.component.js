import React, { Component } from "react";
import UserService from "../services/user.service";
import ReactPaginate from "react-paginate";

export default class Users extends Component {
  constructor(props) {
    super(props);

    this.state = {
      listUser: [],
      pages: null,
      userRole: "",
      query: "",
    };
  }

  componentDidMount() {
    UserService.getListUser("", 1).then((res) => {
      if (res) {
        this.setState({ listUser: res.data.users, pages: res.data.pages });
      }
    });
    UserService.getCurrentUser().then((res) => {
      if (res) {
        this.setState({ userRole: res.data.role });
      }
    });
  }

  handlePageClick = (event) => {
    let pages = event.selected + 1;
    const { query } = this.state;
    UserService.getListUser(query, pages).then((res) => {
      if (res) {
        this.setState({ listUser: res.data.users });
      }
    });
  };

  handleDeleteUser = (id) => {
    UserService.deleteUser(id).then((res) => {
      if (res) {
        if (res?.data?.result) {
          window.location.reload();
        } else {
          alert(res.data?.message);
        }
      }
    });
  };

  handleBlockUser = (id) => {
    UserService.blockUser(id).then((res) => {
      if (res?.data?.result) {
        window.location.reload();
      } else {
        alert(res.data?.message);
      }
    });
  };

  handleChangeInput = (event) => {
    const query = event.target.value;
    UserService.getListUser(query, 1).then((res) => {
      if (res) {
        this.setState({ listUser: res.data.users, pages: res.data.pages });
      }
    });
  };

  render() {
    let { listUser, pages, userRole } = this.state;

    let users = listUser.map((item) => {
      const { id, username, email, role, is_block } = item;
      return (
        <tr key={id}>
          <td>{id}</td>
          <td>{username}</td>
          <td>{email}</td>
          <td>{role}</td>
          {userRole === "admin" && (
            <>
              <td>{is_block && is_block.toString()}</td>

              {is_block ? (
                <td></td>
              ) : (
                <td>
                  <button onClick={() => this.handleBlockUser(id)}>
                    Block
                  </button>
                </td>
              )}

              <td>
                <button onClick={() => this.handleDeleteUser(id)}>
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
        <input
          className="query"
          type="text"
          placeholder="Search..."
          onChange={this.handleChangeInput}
        />

        <table className="Table">
          <thead>
            <tr>
              <th>S/N</th>
              <th>Username</th>
              <th>Email</th>
              <th>Role</th>
              {userRole === "admin" && (
                <>
                  <th>Block User</th>
                  <th colSpan={2}>Edit</th>
                </>
              )}
            </tr>
          </thead>
          <tbody>{users}</tbody>
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
