class Post < Sequel::Model
	def body_html
		RDiscount.new(body).to_html
	end
end
