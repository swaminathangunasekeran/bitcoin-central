module ApplicationHelper
  # Displays a menu option if the logged-in user matches the optional criteria
  def menu_item(label, link, options = {}, &block)
    if options.blank? or display_menu?(current_user, options)
      content_tag :li do
        out = link_to(content_tag(:span, t(label)), link)
        
        if block
          out += block_is_haml?(block) ? capture_haml(&block) : block.call
        end
        
        out
      end
    end
  end
  
  # Checks whether the option should be displayed to the currently logged-in user
  def display_menu?(user, options)
    options.blank? || (user && (user.admin? || (user.merchant? && options[:merchant]) || (user && options[:logged_in])))
  end

  def number_to_bitcoins(amount, options = {})
    number_to_currency(amount, options.merge({:unit => "BTC"}))
  end

  def number_to_lrusd(amount, options = {})
    number_to_currency(amount, options.merge({:unit => "LRUSD"}))
  end

  def number_to_lreur(amount, options = {})
    number_to_currency(amount, options.merge({:unit => "LREUR"}))
  end

  def amount_field_value(amount)
    if amount.blank? or amount.zero?
      nil
    else
      amount.abs
    end
  end

  def errors_for(model, options = {})
    render :partial => 'layouts/errors', :locals => {
      :model => model,
      :message => options[:message]
    }
  end

  def creation_link(resource, label)
    content_tag :div, :class => "creation-link" do
      link_to "#{image_tag("add.gif", :alt => label, :title => label)} #{label}".html_safe,
        send("new_#{resource}_path")
    end
  end
end
