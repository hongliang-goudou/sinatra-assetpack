require File.expand_path('../test_helper', __FILE__)

class GlobTest < UnitTest
  class App < Sinatra::Base
    set :root, File.expand_path('../app', __FILE__)
    register Sinatra::AssetPack

    assets {
      serve '/js', :from => 'app/js_glob'
      js :a, '/a.js', [ '/js/**/*.js' ]
      js :b, '/b.js', [ '/js/a/b/c2/*.js' ]
      js :c, '/c.js', [ '/js/a/b/*/*.js' ]
    }

    get('/a') { js :a }
    get('/b') { js :b }
    get('/c') { js :c }
  end

  def app
    App
  end

  should "match double-star globs recursively" do
    get '/a'
    assert body.include?("a/b/c1/hello.")
    assert body.include?("a/b/c2/hi.")
    assert body.include?("a/b/c2/hola.")
  end

  should "match single-star globs in filenames" do
    get '/b'
    assert body.include?("a/b/c2/hi.")
    assert body.include?("a/b/c2/hola.")
  end

  should "match single-star globs in paths" do
    get '/c'
    assert body.include?("a/b/c1/hello.")
    assert body.include?("a/b/c2/hi.")
    assert body.include?("a/b/c2/hola.")
  end
end
