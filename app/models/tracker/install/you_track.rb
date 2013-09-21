class Tracker::Install::YouTrack < Tracker::Adapters::YouTrack

  protected
  def process
    DEFAULTS.each { |attr, value| tracker.send("#{attr}=", value) unless tracker.send(attr) }
    setup_observer_role
    setup_observer_user
    setup_issue_difficulty_field
    tracker.move_to_idle
    tracker.send :enqueue_full_update
  end


  def setup_observer_role
    # create role
    conn.put_role(id: tracker.role_name) unless conn.get_role(id: tracker.role_name)
    conn.get_permissions(id: tracker.role_name)
    # add permissions to role
    existing_permissions = conn.document.children.first.children.map{ |permission| permission.attributes['name'].value }
    (PERMISSIONS - existing_permissions).each do |permission|
      conn.post_permission(belongs_to: tracker.role_name, id: permission)
    end
  end

  def setup_observer_user
    # create user
    conn.get_current_user
    attrs = Tracker::Member.attrs_from_xml(conn.document).first
    tracker.password = rand(36**20).to_s(36)

    conn.delete_user(id: tracker.username) if conn.get_user(id: tracker.username)
    conn.put_user(id: tracker.username, password: tracker.password, email: attrs['email'])

    # create group
    conn.put_group(id: tracker.role_name, autoJoin: false) unless conn.get_group(id: tracker.role_name)

    # add user to a group
    conn.get_user_groups(id: tracker.username)
    existing_groups = conn.document.children.first.children.map{ |group| group.attributes['name'].value }
    conn.post_user_group(belongs_to: tracker.username, id: tracker.role_name) unless existing_groups.include? tracker.role_name

    # add role to a group
    conn.get_group_roles(id: tracker.role_name)
    existing_roles = conn.document.children.first.children.map{ |role| role.attributes['name'].value }
    unless existing_roles.include? tracker.role_name
      builder = Nokogiri::XML::Builder.new { |xml| xml.userRole(name: tracker.role_name) {} }
      conn.put_group_role(content_type: 'application/xml',
                          raw_body: builder.to_xml,
                          belongs_to: tracker.role_name,
                          id: tracker.role_name)
    end
  end

  def setup_issue_difficulty_field
    # create enumeration with values
    unless conn.get_enumeration(id: tracker.issue_difficulty_field)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.enumeration(name: tracker.issue_difficulty_field) {
          DIFFICULTY_LEVELS.each { |value_params|
            id = value_params.delete(:id)
            xml.value(value_params) {
              xml.text id
            }
          }
        }
      }
      conn.put_enumerations(content_type: 'application/xml', raw_body: builder.to_xml)
    end

    # create custom field
    unless conn.get_prototype(id: tracker.issue_difficulty_field)
      conn.put_prototype(id: tracker.issue_difficulty_field,
                         typeName: 'enum[1]',
                         defaultBundle: tracker.issue_difficulty_field,
                         isPrivate: false,
                         defaultVisibility: true,
                         autoAttached: true)
    end

    # add custom field to all projects
    conn.get_projects
    existing_projects = conn.document.children.first.children.map{ |project| project.attributes['id'].value }
    existing_projects.each do |project_id|
      unless conn.get_project_custom_field(belongs_to: project_id, id: tracker.issue_difficulty_field)
        conn.put_project_custom_field(belongs_to: project_id,
                                      id: tracker.issue_difficulty_field,
                                      emptyFieldText: 'No effort',
                                      bundle: tracker.issue_difficulty_field)
      end
    end
  end

end