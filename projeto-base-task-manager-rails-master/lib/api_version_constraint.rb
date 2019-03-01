class ApiVersionConstraint
   
   def initialize(options)
     @version = options[:versions]  
     @default = options[:default]
   end

   def matches?(req)
     #@version = req.headers['Accept'].split('.')[2] if req.headers['Accept'].present? #Workaround
     @default || req.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}")
   end

end