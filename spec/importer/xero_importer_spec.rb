require 'spec_helper'

describe 'xero_import' do

  let(:company)       { Company.make! }
  let(:invoice)       { Invoice.make!(company: company) }
  let(:xero_invoice)  { FakeXeroInvoice.new }
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

          it 'should raise an error' do
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

end