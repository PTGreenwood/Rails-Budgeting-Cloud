class BudgetController < ApplicationController

  def show #my Budget`

      cluster = Cassandra.cluster(hosts: ['cassandra0'])

      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      #Stores all users.
      @users = session.execute('SELECT * FROM user_by_age')
      @income = session.execute("SELECT * FROM user_income WHERE userid = #{params[:user]}")
      @expenses = session.execute("SELECT * FROM expenses_by_user WHERE userid = #{params[:user]}")
      @totalExpense = session.execute("SELECT sum(amount) FROM expenses_by_user WHERE userid = #{params[:user]}") #Is the current counter for expenseID
      @totalIncome = session.execute("SELECT sum(amount) FROM user_income WHERE userid = #{params[:user]}") #is the current counter for incomeID
      @incomeCount = session.execute("SELECT count(amount) FROM user_income WHERE userid = #{params[:user]}") #Is the amount of values (row number)
      @expenseCount = session.execute("SELECT count(amount) FROM expenses_by_user WHERE userid = #{params[:user]}") #Is the amount of values (row number)

  end

  #Called when the dropdown box is selected
  def update_values
      selected = params[:selected_user].to_i
      # Re render page.
      redirect_to :action => "show", :user => selected
  end

  def create
  end

  def delete
  end

  # Add a new expense to table
  def new_expense

    cluster = Cassandra.cluster(hosts: ['cassandra0'])
    keyspace = 'infs3208'
    session  = cluster.connect(keyspace)

    selected = params[:user].to_i

    expenseCount = 0
    session.execute("select MAX(expenseid) from expenses_by_user where userid = #{selected}").each do |row|
        expenseCount = row['system.max(expenseid)'].to_i
    end

    # Check if nil in table. If nil then table is empty and make first element 1
    if (expenseCount.present?)
        expenseCount = expenseCount + 1

    else
        expenseCount = 1
    end

    category = params[:expense_category].to_s
    description = params[:expense_description].to_s
    amt = ActionController::Base.helpers.number_with_precision(params[:expense_amt], :precision => 2)

    amt = amt.to_f
    statement = session.prepare('INSERT INTO expenses_by_user (userid, expenseid, category, amount, description) values (?, ?, ?, ?, ?)')
    session.execute(statement, :arguments => [selected, expenseCount, category, amt, description])

    redirect_to :action => "show", :user => selected
  end

  # Add a new income stream to table
  def new_income

      cluster = Cassandra.cluster(hosts: ['cassandra0'])
      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      selected = params[:user].to_i

      incomeCount = 0
      session.execute("select MAX(incomeid) from user_income where userid = #{selected}").each do |row|
          incomeCount = row['system.max(incomeid)'].to_i
      end

      # Check if nil in table. If nil then table is empty and make first element 1
      if (incomeCount.present?)
          incomeCount = incomeCount + 1

      else
          incomeCount = 1
      end

      category = params[:income_category].to_s
      description = params[:income_description].to_s
      amt = ActionController::Base.helpers.number_with_precision(params[:income_amt], :precision => 2)
      amt = amt.to_f

      statement = session.prepare('INSERT INTO user_income (userID, incomeID, category, amount, description) values (?, ?, ?, ?, ?)')
      session.execute(statement, :arguments => [selected, incomeCount, category, amt, description])

      flash[:notice] = "New Income Stream added"
      redirect_to :action => "show", :user => selected
  end

  # Update given row for income
  def update_income_row
      cluster = Cassandra.cluster(hosts: ['cassandra0'])

      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      rowToUpdate = params[:row].to_i
      selected = params[:user].to_i

      newCategory = params[:edit_income_cat].to_s
      newDescription = params[:edit_income_desc].to_s
      newAmt = ActionController::Base.helpers.number_with_precision(params[:edit_income_amt], :precision => 2)
      newAmt = newAmt.to_f

      statement = session.prepare('UPDATE user_income SET category = ?, description = ?, amount = ? where userid = ? and incomeid = ?')
      session.execute(statement, :arguments => [newCategory, newDescription, newAmt, selected, rowToUpdate])

      flash[:notice] = "Income Stream #{rowToUpdate} updated"

      redirect_to :action => "show", :user => selected
  end

  # Update given row for expenses
  def update_expense_row
      cluster = Cassandra.cluster(hosts: ['cassandra0'])
      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      rowToUpdate = params[:row].to_i
      selected = params[:user].to_i

      newCategory = params[:edit_expense_cat].to_s
      newDescription = params[:edit_expense_desc].to_s
      newAmt = ActionController::Base.helpers.number_with_precision(params[:edit_expense_amt], :precision => 2)
      newAmt = newAmt.to_f

      statement = session.prepare('UPDATE expenses_by_user SET category = ?, description = ?, amount = ? where userid = ? and expenseid = ?')
      session.execute(statement, :arguments => [newCategory, newDescription, newAmt, selected, rowToUpdate])

      flash[:notice] = "Expense Stream #{rowToUpdate} updated"

      redirect_to :action => "show", :user => selected
  end

  # Delete income
  def remove_income
      cluster = Cassandra.cluster(hosts: ['cassandra0'])
      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      rowToUpdate = params[:row].to_i
      selected = params[:user].to_i

      statement = session.prepare('DELETE FROM user_income WHERE userid = ? and incomeid = ?')
      session.execute(statement, :arguments => [selected, rowToUpdate])

      flash[:notice] = "Income Stream #{rowToUpdate} removed"

      redirect_to :action => "show", :user => selected
  end

  # Delete expense
  def remove_expense
      cluster = Cassandra.cluster(hosts: ['cassandra0'])
      keyspace = 'infs3208'
      session  = cluster.connect(keyspace)

      rowToUpdate = params[:row].to_i
      selected = params[:user].to_i

      statement = session.prepare('DELETE FROM expenses_by_user WHERE userid = ? and expenseid = ?')
      session.execute(statement, :arguments => [selected, rowToUpdate])

      flash[:notice] = "Expense Stream #{rowToUpdate} removed"

      redirect_to :action => "show", :user => selected
  end
end
