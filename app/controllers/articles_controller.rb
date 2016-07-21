class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit

  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = "Article was succesfully created."
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update

    if @article.update(article_params)
      flash[:notice] = "Article was succesfully updated."
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy

    @article.destroy
    flash[:notice] = "Article was succesfully deleted"
    redirect_to articles_path
  end

  def show

  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
    end

  def set_article
    @article = Article.find(params[:id])
  end

  def require_same_user
    if current_user != @article.user
      flash[:danger] = "Je kan alleen je eigen artikelen bewerken/verwijderen lamlul"
      redirect_to root_path
    end
  end

end