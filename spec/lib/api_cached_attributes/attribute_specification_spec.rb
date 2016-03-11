require 'spec_helper'

describe ApiCachedAttributes::AttributeSpecification do
  let(:attributes_class) do
    stub_base_class "GithubUser" do
      # client { |scope| fake_octokit_client }
      default_resource(&:user)
      named_resource(:rails_repo) do |client|
        client.repo('rails/rails')
      end
      attribute :login
      attribute :description, :rails_repo
    end
  end
  let(:subject)     { described_class.new(:login, attributes_class) }
  let(:alt_subject) { described_class.new(:description, attributes_class) }

  describe '#name (alias #method)' do
    it 'returns the name supplied to the constructor' do
      expect(subject.name).to eq(:login)
    end
  end

  describe '#base_class' do
    it 'returns the base_class supplied to the constructor' do
      expect(subject.base_class).to equal(attributes_class)
    end
  end

  describe '#to_hash' do
    it 'returns a hash representation of the attribute' do
      expect(subject.to_hash).to eq(
        name: :login,
        resource: :default,
        base_class: :github_user,
        location: 'GithubUserAttributes#login'
      )
    end
  end

  describe '#resource_name' do
    it 'returns the resource name of the attribute set on the base_class' do
      expect(subject.resource_name).to eq(:default)
    end
  end

  describe '#scope?' do
    context 'when the scope has not been set' do
      it 'returns false' do
        expect(subject.scope?).to eq(false)
      end
    end

    context 'when the scope has been set' do
      it 'returns true' do
        subject.scope = { access_token: 'abc123' }
        expect(subject.scope?).to eq(true)
      end
    end
  end

  describe '#target_object?' do
    context 'when the target object has not been set' do
      it 'returns false' do
        expect(subject.target_object?).to eq(false)
      end
    end

    context 'when the target object has been set' do
      it 'returns true' do
        subject.target_object = Object.new
        expect(subject.target_object?).to eq(true)
      end
    end
  end
end
