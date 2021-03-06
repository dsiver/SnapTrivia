class MessagesController < ApplicationController

  def index
    @user = current_user
    @unread_messages = Message.unread_messages_by_user_id(@user.id)
    @sent_messages = Message.sent_messages_by_user_id(@user.id)
    @read_messages = Message.read_messages_by_user_id(@user.id)
    respond_to do |format|
      format.html
    end
  end

  def show
    @message = Message.find(params[:id])
    @user = current_user
    if (@user.id == @message.sender_id) || (@user.id == @message.recipient_id)
    else
      respond_to do |format|
        format.html { redirect_to :action => :index, notice: 'No message found' }
      end
    end
  end

  def new
    @user_options = Message.recipient_list(current_user.id).all.map{|u| [ u.name, u.id ] }
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
      else
        format.html { redirect_to :action => :new, notice: 'Error: Please try again.' }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to :back }
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