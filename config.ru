#$LOAD_PATH.push(File.join(__dir__,'lib'))

require 'paystub-sinatra'

run Paystub::Sinatra::PaystubApp
