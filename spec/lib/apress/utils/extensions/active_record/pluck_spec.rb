require "spec_helper"

describe Apress::Utils::Extensions::ActiveRecord::Pluck do
  let!(:bart) { Person.create first_name: 'Bart', last_name: 'Simpson' }
  let!(:homer) { Person.create first_name: 'Homer', last_name: 'Simpson' }
  let!(:phrase_homer) { Phrase.create text: "Do'h", person: homer }
  let!(:first_phrase_bart) { Phrase.create text: 'Eat my shorts!', person: bart }
  let!(:second_phrase_bart) { Phrase.create text: 'Ay, Carramba!', person: bart }

  describe '#pluck' do
    it 'returns all names for model' do
      expect(Person.pluck(:first_name)).to match_array %w(Bart Homer)
    end

    it 'returns all names for scope' do
      expect(Person.where(last_name: 'Simpson').pluck(:first_name)).to match_array %w(Bart Homer)
    end

    it 'returns all names for association' do
      expect(bart.phrases.pluck(:text)).to match_array ['Eat my shorts!', 'Ay, Carramba!']
    end

    it 'returns right result on over joins' do
      result = Person.joins(:phrases).where(phrases: {person_id: homer.id}).pluck('phrases.text')
      expect(result).to match_array ["Do'h"]
    end

    context 'with multiple columns selection' do
      it 'returns all ids and names for model' do
        expect(Person.pluck(:id, :first_name)).
          to match_array [[bart.id, bart.first_name], [homer.id, homer.first_name]]
      end

      it 'returns all ids and names for scope' do
        expect(Person.where(first_name: bart.first_name).pluck(:id, :first_name)).
          to match_array [[bart.id, bart.first_name]]
      end

      it 'returns all ids and texts for association' do
        expect(bart.phrases.pluck(:id, :text)).
          to match_array [[first_phrase_bart.id, first_phrase_bart.text],
                          [second_phrase_bart.id, second_phrase_bart.text]]
      end

      it 'returns right result on over joins' do
        result = Person.joins(:phrases).where(phrases: {person_id: homer.id}).pluck('phrases.id', 'phrases.text')
        expect(result).to match_array [[phrase_homer.id, phrase_homer.text]]
      end
    end
  end
end
