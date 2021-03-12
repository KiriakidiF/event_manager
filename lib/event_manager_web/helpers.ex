defmodule EventManagerWeb.Helpers do

  alias EventManager.Events

  alias EventManager.Invites

  alias EventManager.Users

  alias EventManager.Comments
  alias EventManager.Comments.Comment

  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def is_current_user?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def is_invited_user?(conn, event) do
    user = conn.assigns[:current_user]
    invites = event.invites
    user &&
    Enum.any?(invites,
    fn inv -> inv.user_email == user.email end)
  end

  def get_invite_changeset(conn, event) do
    user = conn.assigns[:current_user]
    invites = event.invites
    invite = Enum.find(invites, nil,
      fn inv -> inv.user_email == user.email end)
    Invites.change_invite(invite)
  end

  def get_comment_changeset(conn, event_id) do
    user = conn.assigns[:current_user]
    comment = %Comment{}
    |> Map.put("event_id", event_id)
    |> Map.put("user_id", user.id)
    Comments.change_comment(comment)
  end

  def get_comment_owner(comment) do
    user = Users.get_user!(comment.user_id)
    user.name
  end

  def get_comments(event_id) do
    event = Events.get_event!(event_id)
    comments = event.comments
    comments
  end

  def owns_comment?(conn, comment) do
    user = conn.assigns[:current_user]
    user.id == comment.user_id
  end

  def get_invite_id(conn, event) do
    user = conn.assigns[:current_user]
    invites = event.invites
    invite = Enum.find(invites, nil,
      fn inv -> inv.user_email == user.email end)
    invite.id
  end

  #Helper to be called by counter functions for replies to an invite
  #require expected string reply
  def count_replies(invites, reply) do
    Enum.reduce(invites, 0,
      fn (inv, count) ->
        if (inv.response == reply) do
          count + 1
        else
          count
        end
      end)
  end

  def count_yes(invites) do
    count_replies(invites, "yes")
  end

  def count_no(invites) do
    count_replies(invites, "no")
  end

  def count_maybe(invites) do
    count_replies(invites, "maybe")
  end

  def count_none(invites) do
    count_replies(invites, "")
  end
end
