defmodule EventManagerWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def is_current_user?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
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
    count_replies(invites, nil)
  end
end
