require 'spec_helper'

describe 'xero_import' do

  let(:company)       { Company.make! }
  let(:customer)      { Customer.make!(name: "fake, false and nonexistent co. ltd") }
  let(:invoice)       { Invoice.make!(company: company) }
  let(:xero_invoice)  { FakeXeroInvoice.new }
  let(:xero_invoice2) { FakeXeroInvoice.new }
  let(:fake_ref)      { "NONSENSE" }
  let(:real_ref)      { xero_invoice.invoice_number }
  let(:fake_id)       { "666666-6666666666666-66666" }

  describe '#import_xero_invoice' do

    context 'if the enspiral invoice is not found by xero invoice ID' do
      before do
        Invoice.stub(:where).with(xero_id: fake_id) { [] }
      end

      context 'and the ensprial invoice does not exist by xero reference' do
        before do
          Invoice.stub(:where).with(xero_reference: fake_id) { [] }
          company.stub(:find_xero_invoice_by_id_or_reference).and_return(xero_invoice)
        end

        it 'should proceed with the import' do
          Invoice.should_receive(:insert_single_invoice).and_return (Invoice.make!(company: company, xero_id: fake_id))

          company.import_xero_invoice(fake_id, true)
        end
      end

      context 'and more than one enspiral invoice exist by xero reference' do
        before do
          Invoice.stub(:where).with(xero_reference: fake_id) { [invoice, Invoice.make!(company: company)] }
        end

        it 'should return an error' do
          expect{company.import_xero_invoice(fake_id)}.to raise_error(XeroErrors::AmbiguousInvoiceError)
        end
      end

      context 'and only one exists by xero reference' do
        before do
          Invoice.stub(:where).with(xero_id: fake_id) { [] }
          Invoice.stub(:where).with(xero_reference: fake_id) { [invoice] }
          company.stub(:find_xero_invoice_by_id_or_reference).with(fake_id)  { xero_invoice }
        end

        context 'and the user has not indicated overwrite' do
          it 'should raise an error with false overwrite' do
            expect{company.import_xero_invoice(fake_id, false)}.to raise_error(XeroErrors::InvoiceAlreadyExistsError)
          end

          it 'should raise an error with empty overwrite' do
            expect{company.import_xero_invoice(fake_id, "")}.to raise_error(XeroErrors::InvoiceAlreadyExistsError)
          end

          it 'should raise an error with nil overwrite' do
            expect{company.import_xero_invoice(fake_id, nil)}.to raise_error(XeroErrors::InvoiceAlreadyExistsError)
          end

          it 'should raise an error with no overwrite' do
            expect{company.import_xero_invoice(fake_id)}.to raise_error(XeroErrors::InvoiceAlreadyExistsError)
          end
        end

        context 'and the invoice is marked as paid' do
          before do
            invoice.update_attribute(:paid, true)
          end

          it 'should raise an error' do
            expect{company.import_xero_invoice(fake_id)}.to raise_error(XeroErrors::EnspiralInvoiceAlreadyPaidError)
          end
        end

        context 'and the user has indicated overwrite' do

          it 'should import the invoice' do
            expect(Invoice.count).to eq 0

            company.import_xero_invoice(fake_id, true)

            expect(Invoice.count).to eq 1
          end

          it 'should import the invoice with affirmative' do
            expect(Invoice.count).to eq 0

            company.import_xero_invoice(fake_id, "affirmative")

            expect(Invoice.count).to eq 1
          end
        end
      end
    end
  end

  describe 'insert_single_invoice' do

    [:voided, :draft, :deleted, :submitted].each do |status|
      context "if the xero invoice is #{status}" do
        before do
          xero_invoice.status = status.upcase
        end

        it 'should throw an error' do
          expect{company.insert_single_invoice(xero_invoice, company.id)}.to raise_error(XeroErrors::InvalidXeroInvoiceStatusError)
        end
      end
    end

    context 'if there is a problem creating the customer' do
      before do
        invalid_customer = double(:customer, valid?: false, save: nil, errors: double(:messages, messages: ["WHARRGARBL!!!"]))
        Customer.stub(:new).and_return(invalid_customer)
      end

      it 'should throw an error' do
        expect{company.insert_single_invoice(xero_invoice, company.id)}.to raise_error(XeroErrors::InvalidCustomerError)
      end
    end

    context 'if there already exists a valid customer with the same name' do
      let!(:customer)    { Customer.make!(name: xero_invoice.contact.name) }

      context 'if the invoice has valid fields' do

        it 'should import properly' do
          Invoice.count.should eq 0

          result = company.insert_single_invoice(xero_invoice, company.id)

          Invoice.count.should eq 1

          expect(result.class).to eq Invoice
          expect(result.xero_id).to eq xero_invoice.invoice_id
          expect(result.customer).to eq customer
          expect(result.amount).to eq xero_invoice.sub_total
          expect(result.date).to eq xero_invoice.date
          expect(result.due).to eq xero_invoice.due_date
          expect(result.total).to eq xero_invoice.total
          expect(result.line_amount_types).to eq xero_invoice.line_amount_types
          expect(result.xero_reference).to eq xero_invoice.invoice_number
          expect(result.currency).to eq xero_invoice.currency_code
          expect(result.company).to eq company
        end
      end

      context 'if the invoice does not have valid fields' do
        before do
          stupid_invoice = double(:invoice, errors: double(:messages, full_messages: ["haha, joke's on you! this is fake!!!!"]))
          Invoice.stub(:new).and_return(stupid_invoice)
          stupid_invoice.stub(:save!).and_raise(ActiveRecord::RecordInvalid.new(stupid_invoice))
        end

        it 'should raise an error' do
          expect{company.insert_single_invoice(xero_invoice, company.id)}.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

  end

  describe 'update_existing_invoice' do
    context "if the xero invoice is voided" do
      before do
        xero_invoice.status = "VOIDED"
      end

      it 'should throw an error' do
        expect{company.update_existing_invoice(xero_invoice, invoice)}.to raise_error(XeroErrors::InvalidXeroInvoiceStatusError)
      end
    end

    context "if it can't find the appropriate enspiral invoice" do
      before do
        Invoice.stub(:find_by_xero_id).and_return(nil)
      end

      it 'should return nothing' do
        expect{company.update_existing_invoice(xero_invoice)}.to raise_error(XeroErrors::CannotFindEnspiralInvoiceError)
      end
    end

    context 'if there is a problem creating the customer' do
      before do
        invalid_customer = Customer.new(name: "wat!")
        invalid_customer.stub(:valid?).and_return(false)
        Customer.stub(:new).and_return(invalid_customer)
      end

      it 'should throw an error' do
        expect{company.update_existing_invoice(xero_invoice, invoice)}.to raise_error(XeroErrors::InvalidCustomerError)
      end
    end

    context 'if a new customer is to be created' do

      it 'should create a new customer' do
        Customer.count.should eq 0

        result = company.update_existing_invoice(xero_invoice, invoice)

        Customer.count.should eq 2
        expect(result.customer.name).to eq xero_invoice.contact.name
        expect(result.company_id).to eq company.id
        expect(result.approved).to eq true
      end

    end

    context 'if there already exists a valid customer with the same name' do
      let!(:customer)    { Customer.make!(name: xero_invoice.contact.name) }

      context 'if the invoice has valid fields' do

        it 'should import properly' do
          Invoice.count.should eq 0

          result = company.update_existing_invoice(xero_invoice, invoice)

          Invoice.count.should eq 1

          expect(result.class).to eq Invoice
          expect(result.xero_id).to eq xero_invoice.invoice_id
          expect(result.customer).to eq customer
          expect(result.amount).to eq xero_invoice.sub_total
          expect(result.date).to eq xero_invoice.date
          expect(result.due).to eq xero_invoice.due_date
          expect(result.total).to eq xero_invoice.total
          expect(result.line_amount_types).to eq xero_invoice.line_amount_types
          expect(result.xero_reference).to eq xero_invoice.invoice_number
          expect(result.currency).to eq xero_invoice.currency_code
          expect(result.company).to eq company
        end
      end

      context 'if the invoice does not have valid fields' do
        before do
          stupid_invoice = Invoice.new paid: false, customer: Customer.new(name: xero_invoice.contact.name)
          Invoice.stub(:new).and_return(stupid_invoice)
          stupid_invoice.stub(:save!).and_raise(ActiveRecord::RecordInvalid.new(stupid_invoice))
        end

        it 'should raise an error' do
          expect{company.update_existing_invoice(xero_invoice, invoice)}.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'if the invoice has already been paid' do
        before do
          stupid_invoice = double(:invoice, paid: true, errors: double(:messages, full_messages: ["haha, joke's on you! this is fake!!!!"]))
          Invoice.stub(:new).and_return(stupid_invoice)
          stupid_invoice.stub(:save!).and_raise(ActiveRecord::RecordInvalid.new(stupid_invoice))
        end

        it 'should raise an error' do
          expect{company.update_existing_invoice(xero_invoice, Invoice.new(customer: customer))}.to raise_error(XeroErrors::EnspiralInvoiceAlreadyPaidError)
        end
      end
    end
  end

  describe '#import_xero_invoices' do
    context "if there is an invoice with an 'imported' flag" do
      before do
        Invoice.stub_chain(:where, :order).and_return([invoice])
      end

      it 'should import starting from the last' do
        company.stub(:find_xero_invoice).and_return xero_invoice
        company.stub(:find_all_xero_invoices).and_return [xero_invoice]
        expect(Invoice).to receive(:import_invoices_from_xero).and_return({count: 1, errors: {}})

        company.import_xero_invoices
      end
    end

    context "if there are no invoices at all" do
      before do
        Invoice.stub_chain(:where, :order).and_return([])
      end

      it 'should import all' do
        expect(company).to receive(:find_all_xero_invoices)
        expect(Invoice).to receive(:import_invoices_from_xero).and_return({count: 1, errors: {}})

        company.import_xero_invoices
      end

      context 'one or more invoices do not import properly' do

        before do
          company.stub(:find_all_xero_invoices).and_return [xero_invoice, xero_invoice2]
          Invoice.stub(:import_invoices_from_xero).and_return({count: 2, errors: {xero_invoice.invoice_number => StandardError.new("YOU CROSSED THE STREAMS!!")}})
        end

        it 'should return the expected result' do
          expect{company.import_xero_invoices}.to change{XeroImportLog.count}.from(0).to(1)

          log = XeroImportLog.last
          expect(log.author_name).to eq "system"
          expect(log.person).to eq nil
          expect(log.company).to eq company
          expect(log.number_of_invoices).to eq 2
          expect(log.invoices_with_errors.count).to eq 1
        end

        it 'should send an email to the admins' do
          mailer = double
          mailer.should_receive(:deliver!)
          Notifier.should_receive(:alert_company_admins_of_failing_invoice_import).and_return(mailer)

          company.import_xero_invoices
        end
      end

    end
  end

end
