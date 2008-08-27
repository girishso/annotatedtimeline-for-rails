module AnnotatedTimeline 

  def annotated_timeline(daily_counts_by_type, element = 'graph', options = {})
  
      html = "<script type=\"text/javascript\" src=\"http://www.google.com/jsapi\"></script>\n<script type=\"text/javascript\"> \n"
      html += "google.load(\"visualization\", \"1\", {packages:[\"annotatedtimeline\"]}); \n"  
      html += "google.setOnLoadCallback(drawChart);"    
      html += "function drawChart(){"  
    	html += "var data = new google.visualization.DataTable(); \n"
  		html += "data.addColumn('date', 'Date'); \n"
  		html += google_graph_data(daily_counts_by_type)
  		html += "var chart = new google.visualization.AnnotatedTimeLine($(\'#{element}\')); \n"
  		html += "chart.draw(data"   
		

  		  if options[:zoomEndTime]
  		    options[:zoomEndTime] = "new Date(#{options[:zoomEndTime].year}, #{options[:zoomEndTime].month-1}, #{options[:zoomEndTime].day})"
  	    end
  	    if options[:zoomStartTime]
  	      options[:zoomStartTime] = "new Date(#{options[:zoomStartTime].year}, #{options[:zoomStartTime].month-1}, #{options[:zoomStartTime].day})"
        end
        if options[:colors]
          options[:colors] = "#{options[:colors].inspect}"
        end
  		  array = options.map{|key,val| key.to_s + ": " + val.to_s}
  		  html += (", {" + array.join(", ") + "}") unless array.empty?
		
  		html += "); } \n"		
  		html += "</script>"
  		html +=	"<div id=\"#{element}\" class=\"google_graph\"></div>"
  
  end

  def google_graph_data(daily_counts_by_type)
    length = daily_counts_by_type.values.size
  
    html=setup_columns daily_counts_by_type
    html+="data.addRows(#{length});\n"
    html+=add_data_points(daily_counts_by_type, length)
    html	
  end

  def setup_columns(daily_counts_by_type)
    html = ""
    daily_counts_by_type.values.first.stringify_keys.sort.each do |type,count|
  		html+="data.addColumn('number', '#{type.to_s.titleize}');\n"
  	end
  	html
  end

  def add_data_points(daily_counts_by_type, length)
    html = ""
    #first sort everything by date
    daily_counts_by_type.sort.each_with_index do |obj, index|
      date, type_and_count = obj
  		date_params = "#{date.year}, #{date.month-1}, #{date.day}"
  		html+="data.setValue(#{index}, 0, new Date(#{date_params}));\n"
    
      #now sort the types alphabetically
  		type_and_count.stringify_keys.sort.each_with_index do |count, index2| 
  			html+="data.setValue(#{index}, #{index2+1}, #{count[1]});\n"
  		end
    end
  	html
  end

end