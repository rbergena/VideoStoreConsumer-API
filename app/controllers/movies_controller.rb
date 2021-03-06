class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
    status: :ok,
    json: @movie.as_json(
    only: [:title, :overview, :release_date, :inventory],
    methods: [:available_inventory]
    )
    )
  end

  def create
    hash = {
      title: params[:title],
      overview: params[:overview],
      release_date: params[:release_date],
      image_url: params[:image_url]
    }
    newMovie = Movie.new(hash)
    newMovie.save
  end

  private

  def require_movie
    puts "************"
    puts params
    puts Movie.find_by(title: params[:title])
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
