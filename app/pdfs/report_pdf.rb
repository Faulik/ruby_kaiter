# Generate pdf report for selected sprint
class ReportPdf < Prawn::Document
  def initialize(sprint)
    super()
    @sprint = sprint
    @daily_rations = DailyRation.includes(:dish, :daily_menu)
                     .where(sprint_id: sprint.id)

    # Content
    header
    # Table for whole sprint
    full_table_content
    # Table by each day
    days_tables_content
    # Footer with date
    footer
  end

  def header
    text "Catering report for #{@sprint.title}", size: 20
  end

  # Table for whole sprint
  def full_table_content
    _rations = squash_rations(format_rations)
    
    move_down(50)

    text "Order for #{@sprint.started_at} to #{@sprint.finished_at}"
    
    build_table(rations_headers + sort_by_id(_rations))

    move_down(10)

    text "Full price for order is #{calculate_full_price(_rations)}"
  end

  # Tables for each day
  def days_tables_content

    by_days(format_rations_with_days).each do |day|
      _date = @sprint.started_at + day[:number]

      move_down(30)

      text "Order for #{_date}"

      build_table(rations_headers + sort_by_id(day[:rations]))

      move_down(10)

      text "Full price for order is #{calculate_full_price(day[:rations])}"
    end
  end

  def footer
    _creation_date = Time.zone.now.strftime('Created at %e %b %Y')
    go_to_page(page_count)
    move_down(710)
    text _creation_date, align: :right, style: :italic, size: 9
  end

  private

  # Build table from two dimensional array of content
  def build_table(content)
    table content do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = %w(DDDDDD FFFFFF)
      self.column_widths = [40, 300, 60, 60, 70]
      self.cell_style = {
        border_width: 0,
        size: 10
      }
    end
  end

  # Headers for rations table
  def rations_headers
    [['#', 'Title', 'Price', 'Quantity', 'Full Price']]
  end

  # Return hash with needed parameters
  def format_rations
    @daily_rations.map do |e|
      [ e.dish_id,
        e.dish.title,
        e.dish.price,
        e.quantity ]
    end
  end
  
  # Return hash with needed parameters and day number
  def format_rations_with_days
    @daily_rations.map do |e|
      [ e.dish_id,
        e.dish.title,
        e.dish.price,
        e.quantity,
        e.daily_menu.day_number ]
    end
  end

  # Group rations by id and sum quantities
  def squash_rations(rations)
    append_full_price rations
      .group_by { |e| e[0] }
      .map { |_, e| squash_quantity e }
  end

  # Sum all quantities
  def squash_quantity(rations)
    rations.reduce { |a, e| a[3] += e[3]; a }
  end

  # Group rations by days and sum quantities
  def by_days(rations)
    rations
      .group_by { |e| e[4] }
      .map do |k, v|
        { number: k,
          rations: squash_rations(v).each { |e| e.delete_at(4) } 
        }
    end
  end

  # Append full price to each item 
  def append_full_price(rations)
    rations.each { |e| e.push(e[2] * e[3]) }
  end

  # Calculate full price for rations
  def calculate_full_price(rations)
    rations.reduce(0) { |a, e| a += e[2] }
  end

  # Sort rations by id
  def sort_by_id(rations)
    rations.sort { |x,y| x[0] <=> y[0] }
  end
end
