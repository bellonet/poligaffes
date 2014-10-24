class YairsController < ApplicationController

	def index
		if params[:search]
			@yairs = Yair.where('name LIKE ?', "%#{params[:search]}%")
		else
  		@yairs = Yair.all
  	end
	end

	def new 
		@yair = Yair.new
	end

	def edit
  	@yair = Yair.find(params[:id])
	end

	def update
  	@yair = Yair.find(params[:id])
 
  	if @yair.update(yair_params)
    	redirect_to @yair
  	else
    	render 'edit'
  	end
	end

	def create
		@yair = Yair.new(yair_params)

		if @yair.save
			redirect_to @yair
		else
			render 'new'
		end
	end

	def show
 		@yair = Yair.find(params[:id])
	end

	def destroy
  	@yair = Yair.find(params[:id])
  	@yair.destroy
 
  	redirect_to yairs_path
	end

	private
  	def yair_params
    	params.require(:yair).permit(:name, :party, :field)
  	end
end
