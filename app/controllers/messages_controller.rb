class MessagesController < ApplicationController

  def index
    @user = current_user
    @messages = Message.order("created_at desc")
    respond_to do |format|
      format.html
      #format.json { render json: @messages }
    end
  end

  def show
    @message = Message.find(params[:id])
    @user = current_user
    if (@user.id == @message.sender_id) || (@user.id == @message.recipient_id)
    else
      respond_to do |format|
        format.html { redirect_to :action => :index, notice: 'No message found' }
        #format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @user_options = User.all.map{|u| [ u.name, u.id ] }
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.sender_name = current_user.name
    @message.recipient_name = User.find(@message.recipient_id).name
    @message.read = Message::UNREAD
    @message.save
    respond_to do |format|
      if @message.save
        format.html { redirect_to :action => :index, notice: 'Message has been sent.' }
        #format.json { render json: @messages }
      else
        format.html { redirect_to :action => :new, notice: 'Error: Please try again.' }
        #format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      #format.json { head :no_content }
    end
  end

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  private

  def message_params
    params.require(:message).permit(:subject, :body, :sender_id, :recipient_id, :read, :sender_name, :recipient_name, :payload)
  end
end