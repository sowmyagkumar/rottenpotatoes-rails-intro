class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.rate.uniq
    sorting = false
    if session[:sort] == nil or (params[:sort]!=session[:sort] and params[:sort]!=nil)
      if params[:sort] == nil and session[:sort] == nil
        sorting = false
      else
        sorting = true
        session[:sort] = params[:sort]
      end
    end  
    if session[:ratings] == nil or params[:commit]!= nil
      if params[:ratings] != nil
        session[:ratings] = params[:ratings]
      else
        session[:ratings] = []
      end
    end
    @rate_checking = session[:ratings]
    if session[:ratings].blank?
      if sorting == true
        @movies = Movie.order(session[:sort])
      else
        @movies = Movie.all
      end
    else 
      if sorting == true
        @movies = Movie.all.select {|i| session[:ratings].include?(i.rating)?true:false}
      else
        @movies = Movie.order("#{session[:sort]}").select {|i| session[:ratings].include?(i.rating)?true:false}
      end
    end
  if session[:sort] == "title"
    @x = "hilite"
    @y = ""
    elsif session[:sort] == "release_date"
      @x = ""
      @y ="hilite"
  end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully created."
    session.clear
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash.keep[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
