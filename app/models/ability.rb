# frozen_string_literal: true

class Ability
  include CanCan::Ability

  #Se definieron los permisos para el administrador y el auxiliar del cliente IPS
  def initialize(user)
    user ||= AdminUser.new # guest user (not logged in)
     
    if user.role == AdminUser::SUPER_ADMIN
      can :manage, :all
    elsif user.role == AdminUser::ADMIN
      can :read, ActiveAdmin::Page, name: 'Dashboard'
      can :manage, Consultation
      can :manage, TraceabilityConsult
      can :manage, Client
      can :manage, ClientUser
      can :manage, Contract
      can :manage, Bill
      can :manage, AdditionalCard
      can :manage, Kit
      can :manage, Device
      cannot :read, SystemManual
      can :manage, ConsultationControl
      can :manage, TraceabilityControl
      cannot :read, AdminUser
      cannot :read, User
      cannot :read, Contact
      cannot :read, HelpDesk
      cannot :read, Insurance
      cannot :read, BodyArea
      cannot :read, Disease
      cannot :read, Department
      cannot :read, Municipality
      cannot :read, PrepayCard
      cannot :read, AppVersion
      cannot :read, TraceabilityAdmin
    elsif user.role == AdminUser::SOPORTE_TECNICO
      can :read, ActiveAdmin::Page, name: 'Dashboard'
      can :manage, Contact
      can :manage, HelpDesk
      cannot :read, TraceabilityAdmin
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
