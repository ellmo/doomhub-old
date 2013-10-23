require 'spec_helper'

describe User do

  context 'registering new' do
    context 'neither login nor email are in use' do
      before do
        Factory.create :user
      end

      it 'should create the user' do
        User.count.should eq 1
      end

      it 'should create another user' do
        Factory.create :user
        User.count.should eq 2
      end
    end

    context 'login is in use but email isn`t' do
      before do
        Factory.create :user
      end

      let(:existing_user) { User.first }

      context 'login is in the same case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, login: existing_user.login
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end

      context 'login tries to use different case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, login: existing_user.login.upcase
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            Factory.create :user, login: existing_user.login.capitalize
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end
    end

    context 'email is in use but login isn`t' do
      before do
        Factory.create :user
      end

      let(:existing_user) { User.first }

      context 'email is in the same case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, email: existing_user.email
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end

      context 'email tries to use different case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, email: existing_user.email.upcase
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            Factory.create :user, email: existing_user.email.capitalize
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end
    end

    context 'both email AND login are in use' do
      before do
        Factory.create :user
      end

      let(:existing_user) { User.first }

      context 'email and login are both in the same case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, login: existing_user.login, email: existing_user.email
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end

      context 'either login or email try to use different case' do
        it 'should raise invalid record error' do
          expect do
            Factory.create :user, login: existing_user.login, email: existing_user.email.capitalize
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            Factory.create :user, login: existing_user.login.capitalize, email:  existing_user.email
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.count.should eq 1
        end
      end
    end
  end

  context 'using find_for_database_authentication method (devise)' do
    context 'user exists' do
      before do
        Factory.create :user
      end

      let(:user) { User.first }

      context 'using login (same case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.login
          user.should eq user_to_be_found
        end
      end

      context 'using email (same case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.email
          user.should eq user_to_be_found
        end
      end

      context 'using login (different case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.login.upcase
          user.should eq user_to_be_found
        end
      end

      context 'using email (different case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.email.capitalize
          user.should eq user_to_be_found
        end
      end
    end
  end

  context 'deleting account' do
    context 'after being deleted' do
      before do
        Factory.create :user
        User.first.destroy
      end

      let(:unscoped_user) { User.unscoped.first }
      let(:delted_user) { User.with_deleted.first }

      it 'should not count the user in normal scopes' do
        User.count.should eq 0
      end

      it 'should still be in the database' do
        User.unscoped.count.should eq 1
      end

      it 'should be in `with_deleted` scope' do
        User.with_deleted.count.should eq 1
      end

      it 'should be the same user' do
        unscoped_user.should eq delted_user
      end

      context 'when creating new account with the same data' do
        it 'should raise invalid record error when using same login' do
          expect do
            Factory.create :user, login: delted_user.login
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.unscoped.count.should eq 1
        end

        it 'should raise invalid record error when using same email' do
          expect do
            Factory.create :user, email: delted_user.email
          end.to raise_error(ActiveRecord::RecordInvalid)
          User.unscoped.count.should eq 1
        end
      end
    end
  end

end
