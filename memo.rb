# frozen_string_literal: true

class Get
  def self.get_contents(id)
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memos['memos'].find { |memo| memo['id'] == id }
  end
end

class Post
  def self.post_contents(title, content)
    id = SecureRandom.uuid
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memos['memos'] << { id:, title:, content: }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end
end

class Patch
  def self.patch_contents(id, title, content)
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    edited_data = { id:, title:, content: }
    memos['memos'].map! { |memo| memo['id'] == id ? edited_data : memo }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end
end

class Delete
  def self.delete_contents(id)
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memo_index = memos['memos'].index { |memo| memo['id'] == id }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end
end
