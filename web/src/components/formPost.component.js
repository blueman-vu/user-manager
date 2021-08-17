import React, { Component, useState } from "react";
import UserService from "../services/user.service";
import PostService from "../services/post.service";
import Form from "react-validation/build/form";
import Input from "react-validation/build/input";
import CheckButton from "react-validation/build/button";

const POST_CREATE = {
  PATH: '/post/create',
}
const POST_DETAILS = {
  PATH: '/post/detail',
}
const POST_EDIT = {
  PATH: '/post/edit',
}

const required = (value) => {
  if (!value) {
    return (
      <div className="alert alert-danger" role="alert">
        This field is required!
      </div>
    );
  }
};

const vtitle = (value) => {
  if (value.length > 50) {
    return (
      <div className="alert alert-danger" role="alert">
        The title must be less than 50 characters
      </div>
    );
  }
};
export default class FormPost extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: '',
      likeCount: 0,
      content: '',
      isPublished: false,
      userRole: '',
      mode: '',
      successful: false,
      aliasName: '',
      message: "",
    };
  }

  componentDidMount() {
    UserService.getCurrentUser().then((res) => {
      if (res) {
        this.setState({ userRole: res.data.role });
      }
    });
    const MODE_MAP = {
      [POST_CREATE.PATH]: 'create',
      [POST_DETAILS.PATH]: 'detail',
      [POST_EDIT.PATH]: 'edit',
    };
    const path = this.props.match.path;
    const mode = MODE_MAP[path?.replace('/:alias_name', '')]
    this.setState(
      {
        mode: mode,
      },
    );
    const { alias_name } = this.props.match.params;

    if (mode !== 'create') {
      PostService.getDetailPost(alias_name).then((res) => {
        if (res.statusText === 'OK') {
          this.setState({
            title: res.data.title,
            content: res.data.content,
            isPublished: res.data.is_published,
            aliasName: res.data.alias_name,
            likeCount: res.data.like_count
          })
        }
      })
    }
  }

  handleChangeField(key, event) {
    this.setState({
      [key]: event.target.value,
    });
  }

  handleBackUrl() {
    this.props.history.push(`/posts`);
  }

  handleSubmit = (e) => {
    e.preventDefault();
    this.setState({
      message: "",
      successful: false,
    });
    this.form.validateAll();
    if (this.checkBtn.context._errors.length === 0) {
      const { title, content, isPublished, mode, aliasName, likeCount } = this.state;
      const params = {
        title,
        content,
        is_published: isPublished,
        like_count: likeCount
      }
      PostService.createPost(params, mode, aliasName).then((res) => {
        console.log(res)
        if (res.data.result){
          this.setState({
            message: res.data.message,
            successful: true,
          })
          this.props.history.push(`/posts`);
        } else {
          this.setState({
            successful: false,
            message: "Title has already been taken",
          });
        }
      })
    }
  }

  handleToggle(event) {
    this.setState({ [event.target.name]: event.target.checked });
  }

  addLike = (e) => {
    e.preventDefault();
    const { aliasName } = this.state
    PostService.likePost(aliasName).then((res) => {
      this.setState({ likeCount: res.data })
    })
  }

  render() {
    const { title, content, mode, isPublished, likeCount } = this.state;
    const isDetail = mode === 'detail'
    return (
      <Form
        ref={(c) => {
          this.form = c;
        }}
      >
        {!this.state.successful && (
          <div className="col-12 col-lg-6 offset-lg-3">
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              {!isDetail &&
                <div style={{ display: 'flex' }}>
                  <Input
                    type="checkbox"
                    onChange={(ev) => this.handleToggle(ev)}
                    name='isPublished'
                    checked={isPublished}
                    disabled={isDetail}
                  /> Publised?
                </div>
              }
              {isDetail &&
                <div>

                  <button onClick={(e) => this.addLike(e)}>
                    ♥ Likes: {likeCount ? likeCount : 0}
                  </button>
                </div>}
            </div>

            <Input
              type="text"
              name='title'
              onChange={(ev) => this.handleChangeField('title', ev)}
              value={title}
              className="form-control my-3"
              placeholder="Title"
              validations={[required, vtitle]}
              disabled={isDetail}
            />
            <textarea
              onChange={(ev) => this.handleChangeField('content', ev)}
              className="form-control my-3"
              placeholder="Content"
              value={content}
              disabled={isDetail}>
            </textarea>
            <div className='button-group'>
              <button className="btn"> <a href='/posts'>Back</a></button>
              {!isDetail &&
                <button onClick={this.handleSubmit} className="btn btn-primary">{mode === 'edit' ? 'Update' : 'Submit'}</button>
              }
            </div>
            {this.state.message && (
              <div className="form-group">
                <div
                  className={
                    this.state.successful
                      ? "alert alert-success"
                      : "alert alert-danger"
                  }
                  role="alert"
                >
                  {this.state.message}
                </div>
              </div>
            )}
            <CheckButton
              style={{ display: "none" }}
              ref={(c) => {
                this.checkBtn = c;
              }}
            />
          </div>
        )
        }
      </Form>
    )
  }
}