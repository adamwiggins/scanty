begin
	DB.create_table :posts do
		column :title, :text
		column :body, :text
		column :slug, :text
		column :tags, :text
		column :created_at, :timestamp
	end
rescue
end

class Post < Sequel::Model
	def url
		d = created_at
		"/past/#{d.year}/#{d.month}/#{d.day}/#{slug}/"
	end

	def body_html
		RDiscount.new(body).to_html
	end

	def summary
		summary, more = split_content(body)
		summary
	end

	def summary_html
		RDiscount.new(summary).to_html
	end

	def more?
		summary, more = split_content(body)
		more
	end

	########

	def split_content(string)
		parts = string.gsub(/\r/, '').split("\n\n")
		show = []
		hide = []
		parts.each do |part|
			if show.join.length < 100
				show << part
			else
				hide << part
			end
		end
		[ RDiscount.new(show.join("\n\n")).to_html, hide.size > 0 ]
	end
end
