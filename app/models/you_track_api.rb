require "uri"
require "net/http"

class YouTrackApi

  POSITIVE_CODES = %w(200 201 202)

  attr_accessor :url, :login, :code, :document, :request, :response, :cookie, :errors, :http, :url_data

  def initialize(url, login, password)
    self.url = url
    self.login = login

    self.url_data = URI.parse(url)
    self.http = Net::HTTP.new(url_data.host, url_data.port)

    if url.starts_with?('https')
      self.http.use_ssl = true
      self.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    post_sign_in(login: login, password: password)
    self.cookie = response.response['set-cookie']
  end

  METHODS = {
    sign_in: %w(user/login post),
    users: %w(admin/user get),
    user: %w(admin/user/:id get post put delete),
    user_groups: %w(admin/user/:id/group get),
    user_group: %w(admin/user/:belongs_to/group/:id post delete),
    user_roles: %w(admin/user/:id/role get),
    groups: %w(admin/group get),
    group: %w(admin/group/:id get post put delete),
    group_roles: %w(admin/group/:id/role get),
    group_role: %w(admin/group/:belongs_to/role/:id put delete),
    projects: %w(admin/project get),
    project: %w(admin/project/:id get post put delete),
    project_custom_fields: %w(admin/project/:id/customfield get),
    project_custom_field: %w(admin/project/:belongs_to/customfield/:id get post put delete),
    project_assignees: %w(admin/project/:id/assignee get),
    issues_by_project: %w(issue/byproject/:id get),
    issue: %w(issue/:id get),
    issues: %w(issue get),
    issue_history: %w(issue/:id/history get),
    current_user: %w(user/current get),
    roles: %w(admin/role get),
    role: %w(admin/role/:id get post put delete),
    permissions: %w(admin/role/:id/permission get),
    permission: %w(admin/role/:belongs_to/permission/:id post delete),
    enumerations: %w(admin/customfield/bundle get put),
    enumeration: %w(admin/customfield/bundle/:id get post delete),
    enumeration_value: %w(admin/customfield/bundle/:belongs_to/:id get post put delete),
    prototypes: %w(admin/customfield/field get),
    prototype: %w(admin/customfield/field/:id get post put delete),
    state_bundle: %w(admin/customfield/stateBundle/:id get post put delete),
    state: %w(admin/customfield/stateBundle/:belongs_to/:id get post put delete),

  }.freeze

  METHODS.each do |method_name, config|
    path = config[0]
    config[1..-1].each do |request_type|
      define_method "#{request_type}_#{method_name}" do |params = {}|
        send("send_request", request_type, path, params)
      end
    end
  end

  def valid?
    errors.nil? and POSITIVE_CODES.include? code
  end

  private
  def make_path(path, type, params)
    url_data.path + '/rest/' + path.
        gsub(':belongs_to', params.delete(:belongs_to).to_s).
        gsub(':id', params.delete(:id).to_s) +
        (type == 'get' ? "?#{URI.encode_www_form(params)}" : "")
  end

  def send_request(type, path, params)
    content_type = params.delete(:content_type)
    raw_body     = params.delete(:raw_body)
    self.request = "Net::HTTP::#{type.camelize}".constantize.new(make_path(path, type, params))
    request.body = raw_body.to_s
    request.add_field("Cookie", cookie) if cookie
    request.set_content_type(content_type) if content_type
    request.set_form_data(params) if params.present?
    response = http.request(request)
    parse(response)
  end

  def parse(response)
    self.code     = response.code
    self.response = response
    self.document = Nokogiri::XML(response.body)
    if POSITIVE_CODES.include?(code)
      self.errors = nil
    else
      self.errors = document.css('error').map(&:content).join(' ')
    end.nil?
  end
end