import React, { Component } from "react";

import UserService from "../services/user.service";

export default class Home extends Component {
  constructor(props) {
    super(props);

    this.state = {
      username: "",
      role: "",
    };
  }

  componentDidMount() {
    UserService.getCurrentUser().then(
      (res) => {
        if (res) {
          this.setState({ username: res.data.username, role: res.data.role });
        }
      },
      (e) => {
        this.props.history.push("/login");
      }
    );
  }

  render() {
    const { username, role } = this.state;
    return (
      <>
        {username && role && (
          <div className="container">
            <header className="jumbotron">
              <h3>Hi {username}</h3>
              <p>You're logged in with React & JWT!!</p>

              <p>
                Your role is: <b>{role}</b>
              </p>

              <p>This page can be accessed by all authenticated users.</p>
            </header>
          </div>
        )}
      </>
    );
  }
}
