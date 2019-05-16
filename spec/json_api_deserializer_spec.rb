RSpec.describe JsonApiDeserializer do
  let(:hash) do
    {
      'data' => {
        'type' => 'photos',
        'id' => 'zorglub',
        'attributes' => {
          'title' => 'Ember Hamster',
          'src' => 'http://example.com/images/productivity.png'
        },
        'relationships' => {
          'author' => {
            'data' => nil
          },
          'photographer' => {
            'data' => { 'type' => 'people', 'id' => '9' }
          },
          'comments' => {
            'data' => [
              { 'type' => 'comments', 'id' => '1' },
              { 'type' => 'comments', 'id' => '2' }
            ]
          }
        }
      }
    }
  end

  let(:illformed_payloads) do
    [nil,
     {},
     {
       'data' => nil
     }, {
       'data' => { 'attributes' => [] }
     }, {
       'data' => { 'relationships' => [] }
     }, {
       'data' => {
         'relationships' => { 'rel' => nil }
       }
     }, {
       'data' => {
         'relationships' => { 'rel' => {} }
       }
     }]
  end

  let(:params) { OpenStruct.new(hash) }

  describe '::parse' do
    it 'parses the attributes out of the hash' do
      expect(JsonApiDeserializer.parse(hash)).to eq(
        {
          id: 'zorglub',
          title: 'Ember Hamster',
          src: 'http://example.com/images/productivity.png',
          author_id: nil,
          photographer_id: '9',
          comment_ids: %w(1 2)
        }
      )
    end

    it 'illformed payloads are safe' do
      illformed_payloads.each do |p|
        parsed_hash = JsonApiDeserializer.parse(p)
        expect(parsed_hash).to eq({})
      end
    end

    it 'illformed payloads are unsafe' do
      illformed_payloads.each do |p|
        expect do
          JsonApiDeserializer.parse!(p)
        end.to raise_error(JsonApiDeserializer::InvalidDocument)
      end
    end

    it 'can filter fields with only' do
      parsed_hash = JsonApiDeserializer.parse!(
        hash, only: [:id, :title, :author]
      )

      expected = {
        id: 'zorglub',
        title: 'Ember Hamster',
        author_id: nil
      }
      expect(parsed_hash).to eq(expected)
    end

    it 'can filter fields with except' do
      parsed_hash = JsonApiDeserializer.parse!(
        hash, except: [:id, :title, :author]
      )

      expected = {
        src: 'http://example.com/images/productivity.png',
        photographer_id: '9',
        comment_ids: %w(1 2)
      }

      expect(parsed_hash).to eq(expected)
    end

    it 'can filter fields with keys' do
      parsed_hash = JsonApiDeserializer.parse!(
        hash, keys: { author: :user, title: :post_title }
      )

      expected = {
        id: 'zorglub',
        post_title: 'Ember Hamster',
        src: 'http://example.com/images/productivity.png',
        user_id: nil,
        photographer_id: '9',
        comment_ids: %w(1 2)
      }

      expect(parsed_hash).to eq(expected)
    end

    it 'polymorphic' do
      parsed_hash = JsonApiDeserializer.parse!(
        hash, polymorphic: [:photographer]
      )

      expected = {
        id: 'zorglub',
        title: 'Ember Hamster',
        src: 'http://example.com/images/productivity.png',
        author_id: nil,
        photographer_id: '9',
        photographer_type: 'Person',
        comment_ids: %w(1 2)
      }

      expect(parsed_hash).to eq(expected)
    end
  end
end
