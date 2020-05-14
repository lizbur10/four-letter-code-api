class BirdsController < ApplicationController

    def index
        birds = Bird.all
        render json: birds
    end

    def random
        rando = Bird.all.sample
        render json: rando
    end

    def appledore
        appledore_birds = get_appledore_birds
        render json: appledore_birds
    end

    def appledore_random
        appledore_rando = get_appledore_birds.sample
        render json: appledore_rando
    end

    def show
        bird = Bird.find(params[:id])
        render json: bird
    end

    def get_appledore_birds
        Bird.all.select { | bird | bird.appledore }
    end

end
