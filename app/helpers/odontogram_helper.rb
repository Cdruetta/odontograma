module OdontogramHelper
  ARCH_WIDTH = 880
  ARCH_CENTER_X = 440
  ARCH_LEFT = 40
  ARCH_RIGHT = 840
  UPPER_BASE_Y = 50
  LOWER_BASE_Y = 370
  CURVE_DEPTH = 90
  MAX_ROTATION = 25
  ARCH_TOOTH_W = 48
  ARCH_TOOTH_H = 62

  def arch_positions(arch_type, teeth_numbers)
    ordered = ordered_for_arch(arch_type, teeth_numbers)
    return [] if ordered.empty?
    count = ordered.length
    total_width = ARCH_RIGHT - ARCH_LEFT
    spacing = count > 1 ? total_width / (count - 1).to_f : 0

    ordered.each_with_index.map do |num, i|
      x = ARCH_LEFT + i * spacing
      dx = (x - ARCH_CENTER_X).to_f / (ARCH_CENTER_X - ARCH_LEFT)
      dx = dx.clamp(-1, 1)
      y_offset = dx * dx * CURVE_DEPTH

      y = arch_type == :upper ? UPPER_BASE_Y + y_offset : LOWER_BASE_Y - y_offset
      rotation = -dx * MAX_ROTATION

      { number: num, x: x.round(1), y: y.round(1), rotation: rotation.round(1) }
    end
  end

  def ordered_for_arch(arch_type, teeth_numbers)
    nums = teeth_numbers.map(&:to_i).sort
    if arch_type == :upper
      left = nums.select { |t| t >= 21 && t <= 28 }.sort.reverse
      right = nums.select { |t| t >= 11 && t <= 18 }.sort
    else
      left = nums.select { |t| t >= 31 && t <= 38 }.sort
      right = nums.select { |t| t >= 41 && t <= 48 }.sort.reverse
    end
    (left + right).map(&:to_s)
  end

  def tooth_shape_class(tooth_number)
    n = tooth_number.to_s.to_i
    arch = n >= 30 ? :lower : :upper
    quad = (n / 10).to_i
    pos = n % 10

    case pos
    when 1, 2 then :incisor
    when 3 then :canine
    when 4, 5 then :premolar
    when 6, 7, 8 then :molar
    else :incisor
    end
  end

  def tooth_face_paths(w, h, tooth_number)
    shape = tooth_shape_class(tooth_number)

    # Crown area (percentage of w/h)
    ct = (h * 0.04).round(1)
    cb = (h * 0.56).round(1)
    c_margin_x = (w * 0.06).round(1)
    ch = cb - ct

    # Face widths as percentages of crown width
    mw = ((w - 2 * c_margin_x) * 0.16).round(1)  # 16% each for M and D
    cw = (w - 2 * c_margin_x - 2 * mw).round(1)   # center width

    # Face region boundaries
    xl = c_margin_x
    xm = xl + mw
    xc = xm + cw
    xr = xc + mw

    yt = ct
    y1 = ct + (ch / 3.0).round(1)
    y2 = ct + (ch * 2 / 3.0).round(1)
    yb = cb

    face_labels_pos = {
      mesial: { x: (xl + xm) / 2, y: (yt + yb) / 2 + 1, label: "M" },
      distal: { x: (xc + xr) / 2, y: (yt + yb) / 2 + 1, label: "D" },
      occlusal: { x: (xm + xc) / 2, y: (yt + y1) / 2 + 2, label: "O/I" },
      vestibular: { x: (xm + xc) / 2, y: (y1 + y2) / 2 + 2, label: "V" },
      palatal: { x: (xm + xc) / 2, y: (y2 + yb) / 2 + 2, label: "P/L" }
    }

    {
      outline: tooth_outline_path(w, h, shape),
      root: tooth_root_path(w, h, shape),
      faces: {
        mesial:    "M #{xl},#{yt} L #{xm},#{yt} L #{xm},#{yb} L #{xl},#{yb} Z",
        distal:    "M #{xc},#{yt} L #{xr},#{yt} L #{xr},#{yb} L #{xc},#{yb} Z",
        occlusal:  "M #{xm},#{yt} L #{xc},#{yt} L #{xc},#{y1} L #{xm},#{y1} Z",
        vestibular:"M #{xm},#{y1} L #{xc},#{y1} L #{xc},#{y2} L #{xm},#{y2} Z",
        palatal:   "M #{xm},#{y2} L #{xc},#{y2} L #{xc},#{yb} L #{xm},#{yb} Z"
      },
      face_labels: face_labels_pos
    }
  end

  private

  def tooth_outline_path(w, h, shape)
    xm = (w / 2.0)
    yt = (h * 0.04).round(1)
    yb = (h * 0.56).round(1)
    ym = ((yt + yb) / 2).round(1)

    case shape
    when :incisor
      # Flat incisal edge, rounded corners, single root start
      l = (w * 0.10).round(1)
      r = (w * 0.90).round(1)
      "M #{l},#{yt} Q #{xm},#{yt - 2} #{r},#{yt} " +
      "Q #{r + 4},#{yt + 2} #{r},#{yt + 6} " +
      "L #{r},#{yb} Q #{r},#{yb + 4} #{r - 6},#{yb + 4} " +
      "L #{l + 6},#{yb + 4} Q #{l},#{yb + 4} #{l},#{yb} " +
      "L #{l},#{yt + 6} Q #{l - 4},#{yt + 2} #{l},#{yt} Z"
    when :canine
      # Pointy incisal edge
      l = (w * 0.12).round(1)
      r = (w * 0.88).round(1)
      "M #{l},#{yt + 8} Q #{xm - 4},#{yt - 4} #{xm},#{yt - 6} " +
      "Q #{xm + 4},#{yt - 4} #{r},#{yt + 8} " +
      "Q #{r + 3},#{yt + 12} #{r},#{yt + 18} " +
      "L #{r},#{yb} Q #{r},#{yb + 4} #{r - 6},#{yb + 4} " +
      "L #{l + 6},#{yb + 4} Q #{l},#{yb + 4} #{l},#{yb} " +
      "L #{l},#{yt + 18} Q #{l - 3},#{yt + 12} #{l},#{yt + 8} Z"
    when :premolar
      # Two cusp bumps
      l = (w * 0.10).round(1)
      r = (w * 0.90).round(1)
      c1 = (xm - w * 0.08).round(1)
      c2 = (xm + w * 0.08).round(1)
      "M #{l},#{yt} Q #{c1},#{yt - 4} #{c1},#{yt - 3} " +
      "Q #{xm},#{yt - 4} #{c2},#{yt - 3} " +
      "Q #{c2},#{yt - 4} #{r},#{yt} " +
      "Q #{r + 3},#{yt + 4} #{r},#{yt + 10} " +
      "L #{r},#{yb} Q #{r},#{yb + 4} #{r - 6},#{yb + 4} " +
      "L #{l + 6},#{yb + 4} Q #{l},#{yb + 4} #{l},#{yb} " +
      "L #{l},#{yt + 10} Q #{l - 3},#{yt + 4} #{l},#{yt} Z"
    when :molar
      # Wide crown fitting within bounds
      l = (w * 0.06).round(1)
      r = (w * 0.94).round(1)
      c1 = (xm - w * 0.12).round(1)
      c2 = (xm + w * 0.12).round(1)
      "M #{l},#{yt} Q #{c1},#{yt - 4} #{c1},#{yt - 3} " +
      "Q #{xm},#{yt - 5} #{c2},#{yt - 3} " +
      "Q #{c2},#{yt - 4} #{r},#{yt} " +
      "Q #{r},#{yt + 6} #{r},#{yt + 14} " +
      "L #{r},#{yb} Q #{r - 2},#{yb + 4} #{r - 6},#{yb + 4} " +
      "L #{l + 6},#{yb + 4} Q #{l + 2},#{yb + 4} #{l},#{yb} " +
      "L #{l},#{yt + 14} Q #{l},#{yt + 6} #{l},#{yt} Z"
    end
  end

  def tooth_root_path(w, h, shape)
    rt = (h * 0.56).round(1)
    rb = (h * 0.94).round(1)
    xm = w / 2.0

    case shape
    when :incisor
      # Single tapered root
      rw = (w * 0.18).round(1)
      l = (xm - rw).round(1)
      r = (xm + rw).round(1)
      "M #{l},#{rt} L #{r},#{rt} " +
      "C #{r},#{rt + 6} #{r - 4},#{rb - 6} #{xm},#{rb} " +
      "C #{l + 4},#{rb - 6} #{l},#{rt + 6} #{l},#{rt} Z"
    when :canine
      # Long single root
      rw = (w * 0.20).round(1)
      l = (xm - rw).round(1)
      r = (xm + rw).round(1)
      "M #{l},#{rt} L #{r},#{rt} " +
      "C #{r},#{rt + 6} #{r - 4},#{rb - 4} #{xm},#{rb} " +
      "C #{l + 4},#{rb - 4} #{l},#{rt + 6} #{l},#{rt} Z"
    when :premolar
      # Short single root
      rw = (w * 0.20).round(1)
      l = (xm - rw).round(1)
      r = (xm + rw).round(1)
      "M #{l},#{rt} L #{r},#{rt} " +
      "C #{r},#{rt + 4} #{r - 3},#{rb - 4} #{xm},#{rb} " +
      "C #{l + 3},#{rb - 4} #{l},#{rt + 4} #{l},#{rt} Z"
    when :molar
      # Two roots (mesial and distal)
      gap = (w * 0.08).round(1)
      rw = (w * 0.16).round(1)
      m1_l = (xm - gap / 2 - rw).round(1)
      m1_r = (xm - gap / 2).round(1)
      m2_l = (xm + gap / 2).round(1)
      m2_r = (xm + gap / 2 + rw).round(1)
      "M #{m1_l},#{rt} L #{m1_r},#{rt} " +
      "C #{m1_r},#{rt + 4} #{m1_r - 3},#{rb - 6} #{m1_l + rw * 0.3},#{rb} " +
      "C #{m1_l + 2},#{rb - 6} #{m1_l},#{rt + 4} #{m1_l},#{rt} Z " +
      "M #{m2_l},#{rt} L #{m2_r},#{rt} " +
      "C #{m2_r},#{rt + 4} #{m2_r - 3},#{rb - 6} #{m2_r - rw * 0.3},#{rb} " +
      "C #{m2_l + 2},#{rb - 6} #{m2_l},#{rt + 4} #{m2_l},#{rt} Z"
    end
  end
end
