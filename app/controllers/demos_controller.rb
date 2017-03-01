class DemosController < ApplicationController
  before_action :admin_session, except: :feed
  before_action :age_limit, only: :destroy
  
  def feed
    @demos = Demo.reorder(created_at: :desc).paginate(page: params[:page])
  end
  
  def new
    @demo = Demo.new
    @demo.wad_username = params[:wad] if params[:wad]
  end
  
  def create
    players, errors = parse_players
    if errors.empty?
      @demo = Demo.create(demo_params)
      if @demo.save
        players.each do |player|
          DemoPlayer.create(demo: @demo, player: player).save
        end
        flash[:info] = "Demo successfully created"
        redirect_to wad_path(@demo.wad)
      else
        render 'new'
      end
    else
      @demo = Demo.new(demo_params)
      @demo.errors.add(:player_list, :not_found, message: 
        "#{errors.join(", ")} not found")
      render 'new'
    end
  end
  
  def destroy
    @demo.destroy
    flash[:info] = "Demo successfully deleted"
    redirect_to root_path
  end
  
  def edit
    @demo = Demo.find(params[:id])
  end
  
  def update
    @demo = Demo.find(params[:id])
    players, errors = parse_players
    if errors.empty?
      if @demo.update(demo_params)
        demo_players = @demo.demo_players
        demo_players.each { |dp| dp.destroy }
        players.each do |player|
          DemoPlayer.create(demo: @demo, player: player).save
        end
        flash[:info] = "Demo successfully updated"
        redirect_to wad_path(@demo.wad)
      else
        render 'edit'
      end
    else
      @demo.errors.add(:player_list, :not_found, message: 
        "#{errors.join(", ")} not found")
      render 'edit'
    end
  end
  
  private
    
    def demo_params
      params.require(:demo).permit(:guys, :tas, :level, :time, :engine,
                                   :levelstat, :wad_username, :category_name,
                                   :recorded_at, :file)
    end
    
    def parse_players
      player_names = params[:demo][:player_list].split(/[\n\r]+/).collect { |i| i.strip }
      players = []
      errors  = []
      player_names.each do |name|
        player = Player.find_by(username: name) || Player.find_by(name: name)
        player.nil? ? errors.push(name.to_s) : players.push(player)
      end
      [players, errors]
    end
    
    # Allows destroy only for new items
    def age_limit
      @demo = Demo.find(params[:id])
      unless @demo && age_in_minutes(@demo) < 30
        flash[:warning] = "That Demo is too old to delete from here"
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to root_url
      end
    end
end
