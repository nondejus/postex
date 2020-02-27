defmodule PostexTest do
  use ExUnit.Case
  alias Postex.Post

  post_one = %{
    author: "Alan Vardy",
    body:
      "<h1>This is a title</h1>\n<p><img src=\"/images/blog/2020/picture.jpg\" alt=\"alt text\" title=\"Awesome picture\" /></p>\n<p>This is text</p>\n",
    date: ~D[2020-03-18],
    description: "Uh huh",
    filename: "posts/2020/03-18-test-two.md",
    data: %{footer: "its a footer"},
    id: "test-two",
    tags: ["three", "two"],
    title: "Such a beautiful test",
    related_posts: []
  }

  post_two = %{
    author: "Alan Vardy",
    body:
      "<h1>This is a title</h1>\n<p><img src=\"/images/blog/2020/picture.jpg\" alt=\"alt text\" title=\"Awesome picture\" /></p>\n<p>This is text</p>\n",
    date: ~D[2020-03-17],
    description: "It is a description",
    data: %{footer: "_some_footer"},
    id: "test-one",
    tags: ["tag one", "three", "two"],
    title: "Test of the testiest variety",
    filename: "posts/2020/03-17-test-one.md",
    related_posts: []
  }

  @post_one struct!(Post, %{post_one | related_posts: [struct!(Post, post_two)]})
  @post_two struct!(Post, %{post_two | related_posts: [struct!(Post, post_one)]})

  test "Can get post" do
    assert Blog.get_post("test-one") == @post_two
  end

  test "Can fetch post" do
    assert Blog.fetch_post("test-one") == {:ok, @post_two}
  end

  test "Can list posts" do
    assert Blog.list_posts() === [@post_one, @post_two]
  end

  test "Can get tags" do
    assert Blog.list_tags() == @post_two.tags
  end

  test "Can get posts associated with tag" do
    assert Blog.posts_tagged_with("tag one") == [@post_two]
    assert Blog.posts_tagged_with("two") == [@post_one, @post_two]
  end

  test "Can get count of tags" do
    assert Blog.tags_with_count() == %{"tag one" => 1, "three" => 2, "two" => 2}
  end
end
