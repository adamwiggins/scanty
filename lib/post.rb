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

require 'rdiscount'
require 'syntax/convertors/html'

class Post < Sequel::Model
	def url
		d = created_at
		"/past/#{d.year}/#{d.month}/#{d.day}/#{slug}/"
	end

	def body_html
		to_html(body)
	end

	def summary
		summary, more = split_content(body)
		summary
	end

	def summary_html
		to_html(summary)
	end

	def more?
		summary, more = split_content(body)
		more
	end

	def linked_tags
		tags.split.inject([]) do |accum, tag|
			accum << "<a href=\"/past/tags/#{tag}\">#{tag}</a>"
		end.join(" ")
	end

	########

	def to_html(markdown)
		h = RDiscount.new(markdown).to_html
		h.gsub(/<code>([^<]+)<\/code>/m) do |block|
			convertor = Syntax::Convertors::HTML.for_syntax "ruby"
			"<code>#{convertor.convert($1)}</code>"
		end
	end

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
		[ to_html(show.join("\n\n")), hide.size > 0 ]
	end
end
