puts "Creando pacientes de ejemplo..."

p1 = Patient.create!(name: "María García", birth_date: Date.new(1990, 5, 15), phone: "555-0101", email: "maria@example.com")
p2 = Patient.create!(name: "Juan Pérez", birth_date: Date.new(1985, 8, 22), phone: "555-0102", email: "juan@example.com")
p3 = Patient.create!(name: "Lucía Martínez", birth_date: Date.new(2018, 3, 10), phone: "555-0103", email: "lucia@example.com")

puts "Creando odontogramas..."

o1 = Odontogram.create!(patient: p1, odontogram_type: "adult", version: 1, user_id: 1)
o2 = Odontogram.create!(patient: p2, odontogram_type: "adult", version: 1, user_id: 1)
o3 = Odontogram.create!(patient: p3, odontogram_type: "child", version: 1, user_id: 1)

puts "Agregando estados de ejemplo..."

[
  [o1, "16", "occlusal", "carious"],
  [o1, "16", "mesial", "carious"],
  [o1, "26", "occlusal", "treated"],
  [o1, "11", "whole", "missing"],
  [o1, "36", "occlusal", "endodontics"],
  [o1, "46", "whole", "prosthesis"],
  [o2, "14", "vestibular", "carious"],
  [o2, "24", "occlusal", "treated"],
  [o2, "34", "whole", "implant"],
  [o3, "54", "occlusal", "carious"],
  [o3, "64", "occlusal", "carious"],
  [o3, "75", "whole", "missing"]
].each do |odonto, tooth, face, state|
  ts = ToothState.create!(odontogram: odonto, tooth_number: tooth, face: face, state: state)
  StateHistory.create!(
    odontogram: odonto,
    tooth_state: ts,
    tooth_number: tooth,
    face: face,
    old_state: "healthy",
    new_state: state,
    user_id: 1,
    changed_at: Time.current
  )
end

puts "¡Listo! Pacientes creados:"
Patient.all.each { |p| puts "  - #{p.name} (#{p.age} años, #{p.adult? ? 'Adulto' : 'Infantil'})" }
