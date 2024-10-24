import './App.css';
import { useState, useEffect } from 'react';

const supabaseUrl = 'http://localhost:8000';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzI5NjIxODAwLAogICJleHAiOiAxODg3Mzg4MjAwCn0.IJ8oRXlyLXuVcLqd4uigG45RxG304nrnWRCt-HUCgNo'

const supabase = createClient(supabaseUrl, supabaseAnonKey);

function App() {
  const [name, setName] = useState('');
  const [age, setAge] = useState('');
  const [users, setUsers] = useState([]);
  const [editUserId, setEditUserId] = useState(null); // Track the user being edited

  const fetchUsers = async () => {
    const { data, error } = await supabase.from('Users').select('*');
    if (error) {
      console.error('Error fetching users:', error.message);
    } else {
      setUsers(data);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (editUserId) {
      // Update existing user
      const { error } = await supabase
        .from('Users')
        .update({ name, age })
        .eq('id', editUserId); // Update user based on ID

      if (error) {
        console.error('Error updating user:', error.message);
      } else {
        setEditUserId(null); // Clear edit state after update
      }
    } else {
      // Insert new user
      const { error } = await supabase.from('Users').insert([{ name, age }]);

      if (error) {
        console.error('Error inserting data:', error.message);
      }
    }

    fetchUsers(); // Refresh users list
    setName('');
    setAge('');
  };

  const handleEdit = (user) => {
    setName(user.name);
    setAge(user.age);
    setEditUserId(user.id); // Set user ID for editing
  };

  const handleDelete = async (userId) => {
    const { error } = await supabase.from('Users').delete().eq('id', userId);
    if (error) {
      console.error('Error deleting user:', error.message);
    } else {
      fetchUsers(); // Refresh users list after deletion
    }
  };

  return (
    <div className="container">
      <h1 className="header">{editUserId ? 'Update User' : 'Add User'}</h1>
      <form className="form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Name:</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
            className="input-field"
            placeholder="Enter name"
          />
        </div>
        <div className="form-group">
          <label>Age:</label>
          <input
            type="number"
            value={age}
            onChange={(e) => setAge(e.target.value)}
            required
            className="input-field"
            placeholder="Enter age"
          />
        </div>
        <button type="submit" className="submit-button">
          {editUserId ? 'Update' : 'Submit'}
        </button>
      </form>

      <h2 className="table-header">Users List</h2>
      {users.length > 0 ? (
        <table className="user-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Age</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.name}</td>
                <td>{user.age}</td>
                <td>
                <div className="action-buttons">
                  <button className="edit-button" onClick={() => handleEdit(user)}>
                    Edit
                  </button>
                  <button className="delete-button" onClick={() => handleDelete(user.id)}>
                    Delete
                  </button>
                </div>
              </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>No users found.</p>
      )}
    </div>
  );
}

export default App;
