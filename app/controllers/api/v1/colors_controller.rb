module Api
  module V1
    class ColorsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_color, only: [:destroy]

      def index
        @colors = current_user.colors
        render json: @colors
      end

      def create
        @color = current_user.colors.build(color_params)
        if @color.save
          render json: @color, status: :created
        else
          render json: { errors: @color.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @color.destroy
        head :no_content
      end

      def reset
        current_user.colors.destroy_all
        head :no_content
      end

      private

      def set_color
        @color = current_user.colors.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Color not found' }, status: :not_found
      end

      def color_params
        params.require(:color).permit(:color_code)
      end
    end
  end
end
