class ThingTypesController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  before_action :set_thing_type, only: [:show, :typed_things]
  before_action :get_thing, only: [:typify_things]
  before_action :authenticate_user!, only: [:typify_things, :index, :show, :typed_things] #[:show, :update, :destroy] [:create, :update, :destroy]
  wrap_parameters :thing_type, include: ["name", "description"]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: [:index]


  #thing_types GET    /api/thing_types(.:format)
  def index # listing all types 
    authorize ThingType #authorize will return a true or a false based on the policy
    @thing_types = policy_scope(ThingType.all)
    render :index
  end

  #thing_typify_things GET    /api/things/:thing_id/typify_things(.:format)
  def typify_things #showing list of all types for a thing if user is an organizer or admin
    authorize @thing, get_types?
    @thing_types = policy_scope(ThingType.all)
  end

  #thing_type GET    /api/thing_types/:id
  def show 
    authorize @thing_type
  end

  #thing_type_typed_thingss GET  /api/thing_types/:thing_type_id/typed_things
  def typed_things
    authorize Thing, :get_typed?
    thing_type = ThingType.find(params[:id])
    @things= thing_type.things

    # Policy scoping and merging seems unnecessary since any authenticated use can view things by type
    # @things=ThingPolicy::Scope.new(current_user,@things).user_roles(true,false)
    # @things=ThingPolicy.merge(@things)
    render "things/index"
  end

  private

    def set_thing_type
      @thing_type = ThingType.find(params[:id])
    end
    def get_thing
      @thing ||= Thing.find(params[:thing_id])
    end

    def thing_type_params
      params.require(:thing_type).tap {|p|
          p.require(:name) #throws ActionController::ParameterMissing
        }.permit(:name, :description)
    end
end
