require 'spec_helper'

module Enspiral
  module MoneyTree
    describe FundsTransferTemplate do
      describe 'coffee club example' do
        before :each do
          # setup company and accounts
          @company = Enspiral::CompanyNet::Company.create!(name: 'unspiral', default_contribution: 0.9)
          @allans_account = Account.make!(company: @company, min_balance: -100)
          @robs_account = Account.make!(company: @company, min_balance: -100)
          @coffee_club_account = Account.make!(company: @company)

          @alanna = Enspiral::CompanyNet::Person.make!(:admin)

          @ftt = FundsTransferTemplate.new(company: @company,
                                           name: 'coffee club',
                                           description: 'your monthly subscription to the coffee club')

          @ftt.lines.build source_account: @allans_account,
                           destination_account: @coffee_club_account,
                           amount: 6

          line = @ftt.lines.build source_account: @robs_account,
                           destination_account: @coffee_club_account,
                           amount: 10
          @ftt.save
        end

        it 'saves without error' do
          @ftt.should be_valid
        end

        describe 'generating funds transfers' do
          before :each do
            lambda{
              @ftt.generate_funds_transfers(author: @alanna)
            }.should change(FundsTransfer, :count).by(2)
            @robs_ft = FundsTransfer.where(source_account_id: @robs_account.id).last
            @allans_ft = FundsTransfer.where(source_account_id: @allans_account.id).last
          end

          it 'sets desination account' do
            @robs_ft.destination_account.should == @coffee_club_account
          end

          it 'sets the author' do
            @robs_ft.author.should == @alanna
          end

          it 'sets the correct amounts' do
            @robs_ft.amount.should == 10
            @allans_ft.amount.should == 6
          end
        end

        it 'generates no transfers if one fails' do
          #make allans transfer invalid
          @allans_account.min_balance = 0
          lambda{
            @ftt.generate_funds_transfers(author: @alanna)
          }.should change(FundsTransfer, :count).by(0)
        end
      end
    end
  end
end