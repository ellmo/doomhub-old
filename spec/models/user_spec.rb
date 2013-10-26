require 'spec_helper'

describe User do

  context '.create' do
    context 'login and email are unique' do
      before do
        FactoryGirl.create :user
      end

      it 'should succeed' do
        expect(User.count).to eq 1
      end

      it 'should succeed for two different users' do
        FactoryGirl.create :user
        expect(User.count).to eq 2
      end
    end

    context 'credentials are not unique' do
      let!(:existing_user) { FactoryGirl.create :user }

      context 'login is in use' do
        context 'login uses the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :user, login: existing_user.login }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end

        context 'login is upcased' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :user, login: existing_user.login.upcase }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end

        context 'login is capitalized' do
          it "should raise RecordInvalid" do
            expect { FactoryGirl.create :user, login: existing_user.login.capitalize }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end
      end

      context 'login is in use by destroyed account' do
        let!(:deleted_user) { existing_user.destroy }

        it 'should raise RecordInvalid' do
          expect do
            FactoryGirl.create :user, login: deleted_user.login
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
        it 'should not add user' do
          expect(User.count).to eq 0
          expect(User.unscoped.count).to eq 1
        end
      end

      context 'email is in use' do
        context 'email uses the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :user, email: existing_user.email }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end

        context 'email is upcased' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :user, email: existing_user.email.upcase }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end

        context 'email is capitalized' do
          it 'should raise RecordInvalid' do
            expect do
              FactoryGirl.create :user, email: existing_user.email.capitalize
            end.to raise_error(ActiveRecord::RecordInvalid)
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end
      end

      context 'email is in use by destroyed account' do
        let!(:deleted_user) { existing_user.destroy }

        it 'should raise RecordInvalid' do
          expect do
              FactoryGirl.create :user, email: deleted_user.email
            end.to raise_error(ActiveRecord::RecordInvalid)
            expect(User.unscoped.count).to eq 1
        end

        it 'should not add user' do
          expect(User.count).to eq 0
          expect(User.unscoped.count).to eq 1
        end
      end

      context 'both email and login are in use' do
        context 'they use the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :user, login: existing_user.login, email: existing_user.email }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add user' do
            expect(User.count).to eq 1
          end
        end
      end
    end
  end

  context '#find_for_database_authentication' do
    context 'when user exists' do
      let!(:user) { FactoryGirl.create :user }

      context 'using login (same case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.login
          expect(user).to eq user_to_be_found
        end
      end

      context 'using email (same case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.email
          expect(user).to eq user_to_be_found
        end
      end

      context 'using login (different case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.login.upcase
          expect(user).to eq user_to_be_found
        end
      end

      context 'using email (different case) to log' do
        it 'should find the user' do
          user_to_be_found = User.find_for_database_authentication login: user.email.capitalize
          expect(user).to eq user_to_be_found
        end
      end
    end
  end

  context 'after .destroy' do
    context 'should respect paranoia' do
      before do
        FactoryGirl.create :user
        User.first.destroy
      end

      it 'not present in default scope' do
        expect(User.count).to eq 0
      end

      it 'present in unscoped' do
        expect(User.unscoped.count).to eq 1
      end

      it 'present in .with_deleted' do
        expect(User.with_deleted.count).to eq 1
      end
    end
  end
end
