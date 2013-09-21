class Tracker::Broadcast::Mineral < Tracker::Broadcast::Data

  def prepare
    Game::MINERALS.map do |mineral_name|
      {
          mineral_name: mineral_name,
          mineral_label: I18n.t(mineral_name, scope: "mineral_names"),
          mineral_image_path: "/images/minerals/#{mineral_name}.png"
      }.as_json
    end
  end

end