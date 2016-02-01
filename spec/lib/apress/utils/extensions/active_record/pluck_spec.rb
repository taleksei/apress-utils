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
  end
end
