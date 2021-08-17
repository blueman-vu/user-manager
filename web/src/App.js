import React, { Component } from "react";
import { Switch, Route, Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";

import AuthService from "./services/auth.service";
import UserService from "./services/user.service";

import Login from "./components/login.component";
import Register from "./components/register.component";
import Home from "./components/home.component";
import Users from "./components/users.component";
import Posts from "./components/posts.component";
import FormPost from "./components/formPost.component";

class App extends Component {
  constructor(props) {
    super(props);
    this.logOut = this.logOut.bind(this);

    this.state = {
      currentUser: null,
    };
  }

  componentDidMount() {
    UserService.getCurrentUser().then((res) => {
      if (res.status === 200) {
        this.setState({ currentUser: res.data });
      }
    });
  }

  logOut() {
    AuthService.logout();
  }

  render() {
    const { currentUser } = this.state;
    return (
      <div>
        <nav className="navbar navbar-expand navbar-dark bg-dark">
          <Link to={"/"} className="navbar-brand">
            freeC
          </Link>

          {currentUser &&
            <div className="navbar-nav ml-auto">
              <li className="nav-item">
                <Link to={"/home"} className="nav-link">
                  Home
                </Link>
              </li>
              <li className="nav-item">
                <Link to={"/users"} className="nav-link">
                  Users
                </Link>
              </li>
              <li className="nav-item">
                <Link to={"/posts"} className="nav-link">
                  Posts
                </Link>
              </li>
              <li className="nav-item">
                <a href="/login" className="nav-link" onClick={this.logOut}>
                  LogOut
                </a>
              </li>
            </div>
          }
        </nav>

        <div className="container mt-3">
          <Switch>
            <Route exact path={["/", "/home"]} component={Home} />
            <Route exact path="/login" component={Login} />
            <Route exact path="/users" component={Users} />
            <Route exact path="/posts" component={Posts} />
            <Route exact path="/register" component={Register} />
            <Route path="/post/create" component={FormPost} />
            <Route path="/post/detail/:alias_name" component={FormPost} exact={true} />
            <Route path="/post/edit/:alias_name" component={FormPost} exact={true} />
          </Switch>
        </div>
      </div>
    );
  }
}

export default App;
